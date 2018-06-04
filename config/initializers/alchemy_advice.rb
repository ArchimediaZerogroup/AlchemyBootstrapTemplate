Alchemy::Modules.register_module({
                                     name: 'advice',
                                     order: 1,
                                     navigation: {
                                         name: 'modules.advice',
                                         controller: '/admin/advices',
                                         action: 'index',
                                         image: 'alchemy/newspapers.png',
                                         sub_navigation: [{
                                                              name: 'modules.arguments',
                                                              controller: '/admin/arguments',
                                                              action: 'index'
                                                          }]
                                     }
                                 })

Alchemy.register_ability(AdviceAbility)
Alchemy.register_ability(ArgumentAbility)
