local Translations = {
    error = {
        ["missing_something"] = "Sembra che ti manchi qualcosa...",
        ["not_enough_police"] = "Non c'è abbastanza Polizia.",
        ["door_open"] = "La porta è già aperta.",
        ["cancelled"] = "Processo Cancellato.",
        ["didnt_work"] = "Non ha funzionato.",
        ["emty_box"] = "La Scatola E\' Vuota.",
        ["injail"] = "Sei in prigione per %{Time} mesi.",
        ["item_missing"] = "Ti manca un oggetto.",
        ["escaped"] = "Sei scappato... Vai via da lì.!",
        ["do_some_work"] = "Fai qualche lavoro per ridurre la pena, lavoro al momento: %{currentjob} ",
    },
    success = {
        ["found_phone"] = "Hai trovato un telefono.",
        ["time_cut"] = "Hai guadagnato del tempo dalla tua pena.",
        ["free_"] = "Sei libero! Buona Fortuna! :)",
        ["timesup"] = "Il tuo tempo è finito! Controlla il centro visite.",
    },
    info = {
        ["timeleft"] = "Devi ancora scontare... %{JAILTIME} mesi",
        ["lost_job"] = "Sei Disoccupato",
    }
}
Lang = Locale:new({
phrases = Translations,
warnOnMissing = true})
