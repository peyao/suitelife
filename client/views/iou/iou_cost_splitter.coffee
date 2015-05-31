# Returns true if input id is a user whose name is checked, false otherwise
idInUsersList = (id) ->
  checkedUsers = Session.get "checkedUsers"

  if $.inArray(id, checkedUsers) == -1
    return false
  return true

Template.costSplitter.onRendered ->
  Session.set "checkedUsers", []

#checkedUsers : array of user IDs
Template.costSplitter.helpers
  users: ->
    Session.set "checkedUsers", Suites.findOne(Session.get('suite')._id).users
    Suites.findOne(Session.get('suite')._id).users

  userName: (id) ->
    usr = Meteor.users.findOne id
    if usr?.profile?.first_name?
      userName = usr.profile.first_name + " " + usr.profile.last_name

  splitPercent: (id) ->
    if idInUsersList(id) == false
      return 0
    checkedUsers = Session.get "checkedUsers"
    100 / checkedUsers.length

  splitCost: (id) ->
    amount = Session.get "splitAmount"
    checkedUsers = Session.get "checkedUsers"
    if idInUsersList(id) == false or checkedUsers.length == 0 or not amount
      return 0.00
    #Session.get "evenSplitAmount"
    amount / checkedUsers.length

  evenSplitChecked: ->
    # Disable the input boxes
    if (typeof Session.get("evenSplit") == "undefined")
      Session.set "evenSplit", true
      return true
    else
      return Session.get "evenSplit"

Template.costSplitter.events
  'change #even-split-checkbox': (event, template) ->
    Session.set "evenSplit", event.target.checked
    if event.target.checked == true
      $('input[name=split-cost]').prop('disabled', true)
      $('input[name=amount]').prop('disabled', false)
      $('div[name=split-percent]').removeClass('hidden')
    else
      $('input[name=split-cost]').prop('disabled', false)
      $('input[name=amount]').prop('disabled', true)
      $('div[name=split-percent]').addClass('hidden')
    return

  # Sets the evenSplitAmount for use in helpers
  'keyup #amount': (event, template) ->
    checkedUsers = Session.get "checkedUsers"
    Session.set "splitAmount", template.find("#amount").value
    return

  # Uncheck even-split checkbox when user enters input
  'keyup input[name=split-cost]': (e, t) ->
    if Session.get "evenSplit"
      Session.set "evenSplit", false
    return
  'keyup input[name=split-percent]': (e, t) ->
    if Session.get "evenSplit"
      Session.set "evenSplit", false
    return

  # Disable/Enable input boxes
  'change input[name=split-user]': (e, t) ->
    # Sets a session variable called 'split-user-id'
    currentId = e.currentTarget.id.slice(11) #Gets only the userId
    #Session.set('disable-' + currentId, e.target.checked)

    checkedUsers = Session.get "checkedUsers"

    console.log("e.currentTarget.id: " + e.currentTarget.id)
    # Uncheck user: remove user from checkedUsers
    if e.target.checked == false
      checkedUsers.splice(checkedUsers.indexOf(currentId), 1)
      $('#' + e.currentTarget.id).prop('checked', false)
      if not Session.get "evenSplit"
        console.log("cat")
        $('#split-cost-' + currentId).prop('disabled', true)

    # Check user: Add user to checkedUsers only if box is checked
    # and user is not currently in the array
    else if e.target.checked == true and idInUsersList(currentId) == false
      checkedUsers.push(currentId)
      $('#' + e.currentTarget.id).prop('checked', true)

    console.log(checkedUsers)
    Session.set "checkedUsers", checkedUsers

    return

  'submit form': (e) ->
    e.preventDefault()
    # Get all the users with a split-cost of > 0
    checkedUsers = Session.get "checkedUsers"
    console.log("checkedUsers.length: " + checkedUsers.length)

    i = 0
    while i < checkedUsers.length
      # Create an IOU for each of these users
      # We can grab their split-cost by using: #split-cost-theirid
      payerId = $(e.target).find('[name=payer]').val()
      console.log("payerId: " + payerId)
      if checkedUsers[i] == payerId
        console.log("Skipping this user: " + payerId)

      ###
      iou =
        payerId:    $(e.target).find('[name=payer]').val()
        payeeId:    checkedUsers[i]
        reason:     $(e.target).find('[name=reason]').val()
        amount:     $(e.target).find('[name=amount]').val()
        paid:       false
        deleted:    false
        editLog:    [ { "lastEdited": new Date( ).getTime( ),
        "logMessage": Meteor.user( ).profile.first_name + " created the IOU for \"" + $( e.target ).find( '[name=reason]' ).val( ) + ".\"",
        "editType":   "create" } ]

      Meteor.call 'newIou', iou, (error, id) ->
        if error
          return alert(error.reason)
        $('#newIouModal').modal('toggle')
        $('#newIouModal').find('input:text').val('')
        Router.go '/'
        return

      # Everybody owes the payer: input[name=payer]
      ###
      i = i + 1



     
