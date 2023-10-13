local Translations = {
    error = {
        ["missing_something"] = "Parece que você está esquecendo algo...",
        ["not_enough_police"] = "Não há policiais suficientes...",
        ["door_open"] = "A porta já está aberta...",
        ["cancelled"] = "Processo cancelado...",
        ["didnt_work"] = "Não funcionou...",
        ["emty_box"] = "A caixa está vazia...",
        ["injail"] = "Você está na prisão por %{Time} meses...",
        ["item_missing"] = "Você está sem um item...",
        ["escaped"] = "Você escapou... Saia daqui o mais rápido possível!",
        ["do_some_work"] = "Faça algum trabalho para reduzir sua sentença, trabalho atual: %{currentjob}",
        ["security_activated"] = "O nível de segurança mais alto está ativo, fique nas celas!"
    },
    success = {
        ["found_phone"] = "Você encontrou um celular...",
        ["time_cut"] = "Você trabalhou algum tempo para reduzir sua sentença.",
        ["free_"] = "Você está livre! Aproveite! :)",
        ["timesup"] = "Seu tempo acabou! Faça o check-out no centro de visitantes.",
    },
    info = {
        ["timeleft"] = "Você ainda tem que cumprir... %{JAILTIME} meses",
        ["lost_job"] = "Você está desempregado",
        ["job_interaction"] = "[E] Trabalho de Eletricidade",
        ["job_interaction_target"] = "Faça o trabalho de %{job}",
        ["received_property"] = "Você recuperou sua propriedade...",
        ["seized_property"] = "Sua propriedade foi confiscada, você a receberá de volta quando sua pena terminar...",
        ["cells_blip"] = "Celas",
        ["freedom_blip"] = "Recepção da Prisão",
        ["canteen_blip"] = "Cantina",
        ["work_blip"] = "Trabalho na Prisão",
        ["target_freedom_option"] = "Verificar Tempo",
        ["target_canteen_option"] = "Pegar Comida",
        ["police_alert_title"] = "Nova Chamada",
        ["police_alert_description"] = "Rebelião na Prisão",
        ["connecting_device"] = "Conectando Dispositivo",
        ["working_electricity"] = "Conectando Fios"
    }
}

if GetConvar('qb_locale', 'en') == 'pt-br' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
