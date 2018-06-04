Alchemy::Modules.register_module({
  name: 'arguments',
  order: 1,
  navigation: {
    name: 'modules.arguments',
    controller: '/admin/arguments',
    action: 'index',
    # image: 'alchemy/advice_module.png',
    # sub_navigation: [{
    #   name: 'modules.advice',
    #   controller: '/admin/advice',
    #   action: 'index'
    # }]
  }
})

Alchemy.register_ability(ArgumentAbility)
