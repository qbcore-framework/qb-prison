local Translations = {
    error = {
        ["missing_something"] = "Parece que olvidas algo..",
        ["not_enough_police"] = "No hay suficiente policia..",
        ["door_open"] = "La puerta esta actualmente abierta..",
        ["cancelled"] = "Proceso cancelado..",
        ["didnt_work"] = "Esto no funcionara..",
        ["emty_box"] = "la caja esta vacia..",
        ["injail"] = "Estas en la carcel por %{Time} meses..",
        ["item_missing"] = "Estas olvidando un objeto..",
        ["escaped"] = "Has escapado... Vete lejos de aca.!",
        ["do_some_work"] = "Has trabajos para pasar el rato, trabajo: %{currentjob} ",
        ["security_activated"] = "El más alto nivel de seguridad está activo, manténgase con las celdas!"
    },
    success = {
        ["found_phone"] = "Encontraste un telefono..",
        ["time_cut"] = "Has trabajado en algo y se te ha otorgado una baja de sentencia.",
        ["free_"] = "Estas libre! Disfrutalo! :)",
        ["timesup"] = "Tu tiempo se ha cumplido! Pasate por el Centro de Visitantes",
    },
    info = {
        ["timeleft"] = "Tienes que esperar... %{JAILTIME} meses",
        ["lost_job"] = "Estás desempleado",
        ["job_interaction"] = "[E] Trabajo de electricidad",
        ["job_interaction_target"] = "Has %{job} trabajo",
        ["received_property"] = "Recibiste tus pertenencias de nuevo..",
        ["seized_property"] = "Sus propiedades han sido incautadas, recuperarás todo cuando cumplas tu condena..",
        ["cells_blip"] = "Celdas",
        ["freedom_blip"] = "Recepción de la cárcel",
        ["canteen_blip"] = "Comedor",
        ["work_blip"] = "Trabajo de prisión",
        ["target_freedom_option"] = "Revisar Tiempo",
        ["target_canteen_option"] = "Obtener Comida",
        ["police_alert_title"] = "Nueva llamada",
        ["police_alert_description"] = "Fuga en la prisión",
        ["connecting_device"] = "Conectando dispositivo",
        ["working_electricity"] = "Conectando cables"
    }
}
Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
