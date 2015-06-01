Template.Home.rendered = ->
	modules = ['postsModule', 'iousModule', 'calModule', 'choresModule']
	bodies = ['postsList', 'iousList', 'choreCal', 'choresList']	
	resizing = false

	$( ".panel").resizable(
		grid: [ 40, 20 ]
	)

	$(".chores-panel").resizable(
		grid: [ 40, 20 ]
		alsoResize: ".choreCal"
	)

	$container = $('#home').packery(
		columnWidth: 20
		rowHeight: 10
		gutter: 30)
	# get item elements, jQuery-ify them
	$itemElems = $container.find('.packery-item')
	# make item elements draggable
	$itemElems.draggable(
			handle: "h3"
		)
	# bind Draggable events to Packery
	$container.packery 'bindUIDraggableEvents', $itemElems


	#save the window size to the user
	for i in [0...modules.length]
		do (i) ->

			moduleName = modules[i]
			bodyName = bodies[i]
			padding = 88

			targetContainer = $('#' + moduleName)
			target = $('#' + moduleName)
			targetBody = $('#' + bodyName)

			#run update when targets move
			$container.packery 'on', 'layoutComplete', (laidOutItems) ->
				Meteor.call 'updateModuleLocation', moduleName, null, $('#' + moduleName).position(), (error) ->
					if error
						sAlert.error(error.reason)
				targetBody.height(target.height() - padding)
					
			#run update on resize
			target.resizable 
				stop: (event, ui) ->
					#update sizes	
					Meteor.call 'updateModuleLocation', moduleName, ui.size, null, (error) ->
						if error
							sAlert.error(error.reason)
					resizing = false
				resize: (event, ui) ->
					resizing = true
					#move all objects to fit
					$container.packery()	

			#set the window size
			Tracker.autorun ->
				if !resizing and Meteor.user()?.modules?[moduleName]?
					location = Meteor.user().modules[moduleName]
					target.width(location.width)
					target.height(location.height)
					if location.top?
						targetContainer.css('top', location.top)
						targetContainer.css('left', location.left)					
			
	$container.packery()	
