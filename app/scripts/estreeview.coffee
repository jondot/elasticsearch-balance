@ESTreeView = Ember.View.extend
  didInsertElement: ->
    @spinner = $('#es-tree-view-spinner')

  renderTree: (->
    @spinner.show()
    u = @get('parentView.url')
    return unless u

    d3.json "#{u}/_cluster/nodes", (error, nodes)=>
      if error
        @spinner.hide()
        console.log "XHR Error:", error
        return


      d3.json "#{@get('parentView.url')}/_status", (error, status)=>
        @spinner.hide()
        if error
          console.log "XHR Error:", error
          return

        margin = {top: 40, right: 10, bottom: 10, left: 10}
        width = 1252
        height = 500

        # yuck!
        palette1 = [ 
          '#A35840',
          '#DC4B41',
          '#E6E4AF',
          '#7C7B4A',
          '#B2B4A5',
          '#505937',
          '#A7C269',
          '#F7BA18',
          '#FDFEFD',
          '#58B0D5',
          '#A0DCF8'
        ]
        # yuck!
        palette2 = [ '#69D2E7',
                    '#A7DBD8',
                    '#E0E4CC',
                    '#F38630',
                    '#FA6900',
                    '#CBE86B',
                    '#556270',
                    '#4ECDC4',
                    '#C7F464',
                    '#FF6B6B'
                    ]
        # color = d3.scale.ordinal().range(palette)

        # hmpf, take colorbrewer colors then; no time right now.
        color = d3.scale.category20c()
        sizes = d3.format(",.2s")
        treemap = d3.layout.treemap()
          .size([width, height])
          .sticky(true)
          .padding( (d)-> if(d.type == "node") then 25 else null )
          .value ( (d)-> d.size )


        # XXX hack. replace with proper cleanup either from Ember or D3's side.
        $("##{this.elementId}").empty()

        div = d3.select("##{this.elementId}").append("div")
          .style("position", "relative")
          .style("width", (width + margin.left + margin.right) + "px")
          .style("height", (height + margin.top + margin.bottom) + "px")

        data = new ESTreeMap().process_node(nodes, status)

        status = data[1]
        indexmap = data[0]
        indexlabels = _.keys(indexmap)

        color.domain(indexlabels)

        legend = d3.select("##{this.elementId}").append("div")
          .attr("class", "legend")
          .attr("width", "100%")
          .attr("height", 20 * color.domain().length)
          .selectAll("div")
            .data(indexlabels)
          .enter()
            .append("div")
            .attr("class","legend")

        legend.append("div")
            .attr("class", "legend-color")
            .attr("height", 18)
            .style("background", color)

        legend.append("div")
          .attr("class", "legend-label")
          .text (k)-> k + ", " + sizes(indexmap[k]) + " (replicated)"

    
        node = div.datum(status).selectAll(".node")
          .data(treemap.nodes)
          .enter().append("div")
          .attr("class", "node")
          .style("left", (d)-> d.x + "px")
          .style("top", (d)->  d.y + "px")
          .style("width", (d)->  Math.max(0, d.dx - 1) + "px")
          .style("height", (d)->  Math.max(0, d.dy - 1) + "px")
          .style("background", (d) -> if(d.children) then color(d.colortag) else null)
          .text (d)->
            if(d.type=="node")
              return d.label

            if( d.children )
              return null

            sizes(d.size)

  ).observes('parentView.url')



