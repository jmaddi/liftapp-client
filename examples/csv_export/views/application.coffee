

UserModel = ->
  self = this

  self.email    = ko.observable()
  self.password = ko.observable()

  self.subscriptions = ko.observableArray()

  self.login = ->
    $.post('/dashboard.json', {email: self.email(), password: self.password()}, (data) ->
      ko.mapping.fromJS(data, {}, self)
    )
    false
    
  return
  
ko.applyBindings(window.viewModel = new UserModel())

$(document).ajaxSend(->
  $('#btnLogin').button('loading')
)

$(document).ajaxComplete(->
  $('#btnLogin').button('reset')
)
