root = exports ? this
root.Chores = new (Meteor.Collection)('chores')
# Note: this will allow ALL users to insert, update, and delete Chores
Meteor.methods
  deleteChore: (id) ->
    Chores.remove id
    return
  newChore: (chore) ->
    chore.createdAt = (new Date).getTime()
    id = Chores.insert(chore)
    id
  editChore: (chore, id) ->
    chore.updatedAt = (new Date).getTime()
    Chores.update id, $set: chore
    id