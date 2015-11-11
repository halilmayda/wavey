
class @AudioTrack extends E.Component
	render: ->
		{track, selection, position, playing} = @props
		
		E ".track.audio-track",
			E TrackControls
			E ".track-content",
				ref: "content"
				style:
					position: "relative"
					height: 80 # = canvas height
					boxSizing: "content-box"
				for clip in track.clips
					E AudioClip,
						key: clip.id
						id: clip.id
						data: audio_buffer_for_clip clip.id
						style:
							position: "absolute"
							left: clip.time * scale
				if selection?
					E ".selection",
						key: "selection"
						style:
							left: scale * selection.start()
							width: scale * (selection.end() - selection.start())
				if position?
					E ".position",
						ref: (c)=> @position_indicator = c
						key: "position"
						style:
							left: scale * position
	
	animate: ->
		@animation = requestAnimationFrame => @animate()
		if @props.playing
			if @position_indicator
				@position_indicator.getDOMNode().style.left =
					"#{(scale * (actx.currentTime - @last_position_update_time))}px"
	
	componentDidUpdate: (last_props)->
		if @props.position isnt last_props.position
			@last_position_update_time = actx.currentTime - @props.position
	
	componentDidMount: ->
		@animate()
	
	componentWillUnmount: ->
		cancelAnimationFrame @animation
