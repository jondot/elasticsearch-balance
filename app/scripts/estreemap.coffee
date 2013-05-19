log = console.log
log = (foo, bar)->


class @ESTreeMap
  process:(stats)->
    { 
      "name" : "root",
      "children" : _.map stats.indices, (index, name)->
        log "processing index #{name} with #{index.shards.length} shards"
        {
          "name":name,
          "children": _.map index.shards, (shard, si)->
            log "\tprocessing shard ##{si} with #{shard.length} replicas"
            {
              "name": "i-#{name}/#{si}",
              "children": _.map shard, (replica, ri)->
                log "\t\tprocessing replica ##{ri} with #{shard.length} replicas"
                log "\t\t\t Node: #{replica.routing.node}, docs: #{replica.docs.num_docs}"
                {
                  "name": "#{name}:s#{si}:#{ri}",
                  "size":replica.docs.num_docs
                }
            }
        }
    }
  smartpath: ()->
    shift = [].shift
    hsh = shift.apply(arguments)
    while arg = shift.apply(arguments)
      unless hsh[arg]
        hsh[arg] = {}
      hsh = hsh[arg]

    hsh



  process_node:(clusternodes, stats)->
    res = {}
    res["name"] = 'root'
    indexmap = {}

    #
    # node
    #  -index1
    #    -shard
    #      -replica
    #  -index2
    #
    inverted = _.map stats.indices, (index, name)=>
        _.map index.shards, (shard, si)=>
            _.map shard, (replica, ri)=>
                log ['children', replica.routing.node, "indices", name, "s-#{si}", "r-#{ri}"].join(":")
                @smartpath(res, 'nodes', replica.routing.node, "indices", name, "shards", "s-#{si}", "replicas", "r-#{ri}")["size"] = replica.docs.num_docs



     total = { 
      "name" : "root",
      "children" : _.map res.nodes, (node, name)->
        log "processing node #{name}"
        {
          "name":name,
          "label": "#{clusternodes.nodes[name].name} (#{clusternodes.nodes[name].version})",
          "type": "node",
          "children": _.map node.indices, (index, iname)->
            log "\tprocessing index #{iname}"
            {
              "name": "#{iname}:#{name}",
              "label": iname,
              "colortag": iname,
              
              "children": _.map index.shards, (shard, sname)->
                log "\t\tprocessing shard #{sname}"
                {
                  "name": "#{sname}:#{iname}:#{name}",
                  "colortag": iname,
                  "label": sname,
                  "children": _.map shard.replicas, (replica, rname)->
                    indexmap[iname] ||=0
                    indexmap[iname] += replica.size

                    log "\t\t\tprocessing replica #{rname}"
                    {
                      "name": "#{rname}:#{sname}:#{iname}:#{name}",
                      "label": "#{rname}, #{replica.size} docs",
                      "colortag": iname,
                      "size": replica.size
                    }
                }
            }
        }
    }

    [indexmap, total]




