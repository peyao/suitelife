Router.map ->
  @route 'choresList', path: '/chores/list'
  @route 'choreNew',
    path: '/chore/new'
    template: 'choreNew'
  @route 'choreEdit',
    path: '/chore/:_id/edit'
    template: 'choreEdit'
    data: ->
      { chore: Chores.findOne(@params._id) }
  @route 'choreDetail',
    path: '/chore/:_id/detail'
    template: 'choreDetail'
    data: ->
      { chore: Chores.findOne(@params._id) }
  return