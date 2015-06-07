root = exports ? this
root.Chores = new (Meteor.Collection)('chores')
# Note: this will allow ALL users to insert, update, and delete Chores
Meteor.methods
  deleteChore: (id) ->
    Chores.remove id
    #remove id from suite
    suite = (Suites.findOne users: Meteor.userId())
    index = suite.chore_ids.indexOf(id)
    if (index > -1) 
      suite.chore_ids.splice(index, 1);
      Suites.update suite._id, $set: {chore_ids: suite.chore_ids}
    return
  newChore: (chore, frequency, freqString, freqNum, assignees) ->
    suite = (Suites.findOne users: Meteor.userId())
    if frequency > 0
      repeating = 0
      incDay = 0
      assignCount = assignees.length
      assignIndex = Math.floor(Math.random() * assignCount);
      
      while repeating < freqNum
        startDay = moment(chore.startDate).add incDay, freqString
        chore.startDate = moment(startDay).toDate()

        chore.assignee = assignees[assignIndex]

        chore.createdAt = (new Date).getTime()
        id = Chores.insert(chore)
        
        incDay = 1
        if frequency == 14
          incDay = 2
        
        assignIndex = (assignIndex + 1) % assignCount
        repeating++

        #insert into suite
        if !(suite.chore_ids?)                                            
          Suites.update suite._id, $set: {chore_ids: [id]}
        else
          Suites.update suite._id, $push: {chore_ids: id}
    else
      chore.createdAt = (new Date).getTime()
      id = Chores.insert(chore)
      
      #insert into suite
      if !(suite.chore_ids?)                                            
        Suites.update suite._id, $set: {chore_ids: [id]}
      else
        Suites.update suite._id, $push: {chore_ids: id}

  editChore: (chore, id) ->
    chore.updatedAt = (new Date).getTime()
    Chores.update id, $set: chore
    id
  completeChore: (id) ->
    chore = Chores.findOne id
    isCompleted = chore.completed
    if isCompleted
      Chores.update id, $set:
        completed: false
    else
      Chores.update id, $set:
        completed: true
        completedOn: new Date()
    id
  updateChoreName: (name, id) ->
    Chores.update id, $set:
      title: name
    id
  updateChoreDesc: (desc, id) ->
    Chores.update id, $set:
      description: desc
    id  
  updateChoreAssignee: (assigneeId, id) ->
    Chores.update id, $set:
      assignee: assigneeId
    id
  updateChoreDate: (startDay, id) ->
    Chores.update id, $set:
      startDate: startDay
    id