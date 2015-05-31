Template.Nav.helpers
  getSuiteName: ->
    ## Find and return suite name
    suite = Suites.findOne users: Meteor.userId( )
    if suite?
      suite.name
    else
      ""
  getSuite: ->
    ## Find and return suite
    Suites.findOne users: Meteor.userId()

Template._loginButtonsLoggedInDropdown.helpers
  user_profile_picture: ->
    if Meteor.user()
      'http://www.gravatar.com/avatar/' + CryptoJS.MD5(Meteor.user().emails[0].address).toString()+'?d=retro'

Template._loginButtonsAdditionalLoggedInDropdownActions.events 
  'click #login-buttons-send-invite': (e) ->
    e.preventDefault()
    $('#inviteModal').modal 'show'
    $('#invite-url').val(Meteor.absoluteUrl()+'invite/'+Session.get('suite')._id)
    $('#invite-url:text').focus ->
      $(this).select()
  'click #login-buttons-leave-suite': (e) ->

Template._loginButtonsAdditionalLoggedInDropdownActions.events 
  'click #login-buttons-settings': (e) ->
    e.preventDefault()
    $('#settingsModal').modal 'show'

Template.Nav.events
  'click #delete-my-account': (e) ->
    Meteor.call 'deleteAccount', (error) ->
      if error
        console.log error
        sAlert.error(error.reason)

Template.Nav.rendered = ->
  $('[data-toggle="tooltip"]').tooltip placement:'bottom'

Template.settings.rendered = ->
  $('.switch').bootstrapSwitch();

Template.invite.events 
  'submit form': (e) ->
    e.preventDefault()
    usr = Meteor.user()
    suite = Suites.findOne Session.get('suite')._id
    emails = $(e.target).find('[name=email]').val()
    Meteor.call 'sendEmail', emails, 'SuiteLife <suitelife@suitelife.com>', '[SuiteLife] Invitation', usr.profile['first_name']+' '+usr.profile['last_name']+' invited you to join '+suite.name+' on SuiteLife.'+"\n\r"+'Please click on the following link to signup: '+Meteor.absoluteUrl()+'invite/'+suite._id
    $('#inviteModal').modal 'hide'
    return

Template.settings.events 'submit form': (e) ->
  e.preventDefault()
  sAlert.warning('Settings Functionality currently not implemented')
  $('#inviteModal').modal 'hide'
  return
