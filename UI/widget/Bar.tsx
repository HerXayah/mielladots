import { Astal, Gtk } from "ags/gtk4"
import AstalTray from "gi://AstalTray"
import { createBinding, For } from "ags"
import Cava from "gi://AstalCava"

export default function Bar(monitor = 0) {
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor
  return (
    <window visible anchor={TOP | LEFT | RIGHT} class="Bar" monitor={monitor}>
      <box hexpand>
        {/* Left Section */}
        <box halign={Gtk.Align.START}>
          <box class="POGGIES">Hurensohn</box>
        </box>

        {/* Middle Section: CAVA Visualizer */}
        <box halign={Gtk.Align.CENTER} hexpand>
          {middleBar()}
        </box>

        {/* Right Section: Tray Icons */}
        <box halign={Gtk.Align.END}>
          {tray()}
        </box>
      </box>
    </window>
  )
}

function middleBar() {
  const cava = Cava.get_default()
  if (!cava) return <box>Initializing audio...</box>

  // --- CAVA setup ---
  cava.input = Cava.Input.PIPEWIRE
  cava.bars = 25
  cava.framerate = 60
  cava.autosens = true
  cava.samplerate = 48000
  cava.low_cutoff = 50
  cava.high_cutoff = 10000
  cava.active = true
  cava.source = "44"

  const numBars = cava.bars || 25
  const bars = Array.from({ length: numBars }, (_, i) => ({ id: i, value: 0 }))
  const values = createBinding({ bars }, "bars")
  let displayed = bars.map(b => b.value)

  // --- dynamic scaling ---
  let maxRecent = 1e-12
  const decay = 0.95 // decay factor for smoothing max

  cava.connect("notify::values", () => {
    const vals = cava.get_values()
    print("CAVA values:", vals?.join(", "))
    if (!vals) return

    // Smooth max for gentle scaling
    const currentMax = Math.max(...vals, 1e-6)
    maxRecent = Math.max(currentMax, maxRecent * decay)

    // Smooth interpolation for bars
    displayed = displayed.map((v, i) => v + ((vals[i] || 0) - v) * 0.2)

    // Normalize and boost tiny values
    values.bars = displayed.map(v => {
      let normalized = v / maxRecent
      normalized = Math.pow(normalized, 0.5) // sqrt boost
      normalized = Math.max(normalized, 0.05) // minimum visible height
      return { id: Math.random(), value: normalized } // use random key to force update
    })
  })

  // --- render bars ---
  return (
    <box spacing={3} valign={Gtk.Align.END} heightRequest={50}>
      {values.bars?.length &&
        <For each={() => values.bars} key={b => b.id}>
          {b => (
            <box
              css={`
                min-height: ${Math.max(2, b.value * 50)}px;
                background: linear-gradient(to top, #4fc3f7, #81c784);
                border-radius: 2px;
                transition: min-height 0.05s linear;
              `}
              widthRequest={4}
              valign={Gtk.Align.END}
            />
          )}
        </For>
      }
    </box>
  )
}

function tray() {
  const tray = AstalTray.get_default()
  const items = createBinding(tray, "items")

  const init = (btn: Gtk.MenuButton, item: AstalTray.TrayItem) => {
    btn.menuModel = item.menuModel
    btn.insert_action_group("dbusmenu", item.actionGroup)
    item.connect("notify::action-group", () => {
      btn.insert_action_group("dbusmenu", item.actionGroup)
    })
  }

  return (
    <box>
      <For each={items} key={item => item.id}>
        {item => (
          <menubutton $={self => init(self, item)}>
            <image gicon={createBinding(item, "gicon")} />
          </menubutton>
        )}
      </For>
    </box>
  )
}
