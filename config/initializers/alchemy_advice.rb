Alchemy::Modules.register_module({
  name: 'advice',
  order: 1,
  navigation: {
    name: 'modules.advice',
    controller: '/admin/advices',
    action: 'index',
    image: 'alchemy/newspapers.png'
  }
})

Alchemy.register_ability(AdviceAbility)
