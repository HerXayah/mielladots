import app from "ags/gtk4/app"
import Bar from "./widget/Bar"
import scss from "./style.scss"

app.start({
  css: scss,
  main() {
    Bar(0)
    Bar(1) // instantiate for each monitor
},
})