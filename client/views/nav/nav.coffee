Template._loginButtonsAdditionalLoggedInDropdownActions.events 'click #login-buttons-send-invite': (e) ->
  e.preventDefault()
  $('#inviteModal').modal 'show'

#FIX ME
Template.invite.events 'submit form': (e) ->
  e.preventDefault()
  usr = Meteor.user()
  suite = Suites.findOne users: usr._id
  emails = $(e.target).find('[name=email]').val()
  emails.split(";").map (x) ->
    x = x.trim()
    console.log x
    # Meteor.call
    #   'sendEmail' , 
    #   x, 
    #   usr.emails[0], 
    #   usr.first-name + 
    #     " " + 
    #     usr.last-name +
    #     "'s Invitation to join " +
    #     suite.name + 
    #     " on Suitelife",
    #   usr.first-name + 
    #     " has invited you to join their suite!\n" +
    #     "click " + 
    #     process.env.PWD + 
    #     "/invite/" + 
    #     suite._id +
    #     " to join them on Suitelife"
  return

Accounts.ui.config
  requestPermissions: {}
  extraSignupFields: [
    {
      fieldName: 'first-name'
      fieldLabel: 'First name'
      inputType: 'text'
      visible: true
      validate: (value, errorFunction) ->
        if !value
          errorFunction 'Please write your first name'
          false
        else
          true

    }
    {
      fieldName: 'last-name'
      fieldLabel: 'Last name'
      inputType: 'text'
      visible: true
      validate: (value, errorFunction) ->
        if !value
          errorFunction 'Please write your last name'
          false
        else
          true
    }
  ]
