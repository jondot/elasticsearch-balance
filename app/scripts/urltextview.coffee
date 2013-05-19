@UrlTextView = Em.TextField.extend
  elementId: 'url-input'

  obtainFocusWhenEmpty: (->
    @$().focus() unless @get('value')
  ).observes('value')

  didInsertElement: ()->
    $(document).foundation()
    @focus()

  focus: ->
    @$().focus()

  insertNewline: ()->
    console.log @get('value')
    poll = $("#poller-select").val()

    if @poller
      clearInterval(@poller)
      @poller = null

    if(poll > 0)
      tempval = @get('value')
      @poller = setInterval ()=>
        console.log "Now polling. (set to every #{poll} minutes)"
        @set('url', null)
        @set('url', tempval)
      , 1000*poll*60

    @set('url', @get('value'))



