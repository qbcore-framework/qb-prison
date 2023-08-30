local Translations = {
    error = {
        ["missing_something"] = "Parece que você está esquecendo algo...",
        ["not_enough_police"] = "Não há polícia suficiente...",
        ["door_open"] = "A porta já está aberta...",
        ["cancelled"] = "Processo cancelado...",
        ["didnt_work"] = "Não funcionou...",
        ["empty_box"] = "A caixa está vazia...",
        ["in_jail"] = "Você está na prisão por %{Time} meses...",
        ["item_missing"] = "Está faltando um item...",
        ["escaped"] = "Você escapou... Saia daqui!",
        ["do_some_work"] = "Faça algum trabalho para reduzir a sentença, trabalho atual: %{currentjob}",
        ["security_activated"] = "O nível de segurança mais alto está ativo, fique nas celas!"
    },
    success = {
        ["found_phone"] = "Você encontrou um celular...",
        ["time_cut"] = "Você trabalhou algum tempo de sua sentença...",
        ["free_"] = "Você está livre! Aproveite! :)",
        ["times_up"] = "Seu tempo acabou! Faça o check-out no centro de visitantes...",
    },
    info = {
        ["time_left"] = "Você ainda tem que cumprir... %{JAILTIME} meses...",
        ["lost_job"] = "Você está desempregado...",
        ["job_interaction"] = "[E] Trabalhar com Eletricidade",
        ["job_interaction_target"] = "Faça o trabalho de %{job}",
        ["received_property"] = "Você recuperou sua propriedade...",
        ["seized_property"] = "Sua propriedade foi apreendida, você a receberá de volta quando o tempo acabar...",
        ["cells_blip"] = "Celas",
        ["freedom_blip"] = "Recepção da Prisão",
        ["canteen_blip"] = "Refeitório",
        ["work_blip"] = "Trabalho na Prisão",
        ["target_freedom_option"] = "Verificar tempo",
        ["target_canteen_option"] = "Pegar comida",
        ["police_alert_title"] = "Novo Chamado",
        ["police_alert_description"] = "Rebelião na Prisão",
        ["connecting_device"] = "Conectando Dispositivo",
        ["working_electricity"] = "Conectando Fios"
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
