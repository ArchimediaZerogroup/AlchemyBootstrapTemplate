Alchemy::Modules.register_module({
                                     name: 'user_site_registrations',
                                     order: 1,
                                     navigation: {
                                         name: 'modules.form_newsletter',
                                         controller: '/admin/form_newsletters',
                                         action: 'index',
                                         image: 'alchemy/user_site_registrations_module.png',
                                         sub_navigation: [{
                                                              name: 'modules.form_newsletter',
                                                              controller: '/admin/form_newsletters',
                                                              action: 'index'
                                                          },
                                                          {
                                                              name: 'modules.contact_form',
                                                              controller: '/admin/contact_forms',
                                                              action: 'index'
                                                          }
                                         ]
                                     }
                                 })

Alchemy.register_ability(UserSiteRegistrationAbility)