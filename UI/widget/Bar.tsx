import { Astal, Gtk } from "ags/gtk4"

export default function Bar(monitor = 0) {
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor
  return (
    <window visible anchor={TOP | LEFT | RIGHT} class="Bar" monitor={monitor}>
      <box class="POGGIES" halign={Gtk.Align.CENTER}>Hurensohn</box>
    </window>
  )
}