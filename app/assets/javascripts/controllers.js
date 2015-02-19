'use strict';

// ============================================================================
// Hi-lock: ((" ?[T]o ?Do:.*"                                  (0 'accent10 t)))
// Hi-lock: (("\\(^\\|\\W\\)\\*\\(\\w.*\\w\\)\\*\\(\\W\\|$\\)" (2 'accent3 t)))
// Hi-lock: end
// ============================================================================

/* Controllers */

function ResourceListCtrl($scope, $http) {
  $.extend( $scope,
    {
      init_display_parms: function () {
        TimePix.set_display_parms()
      },

      init_resources: function () {
        $scope.init_display_parms()

        $scope.rsrcs    = UseBlock.rsrcs = TimePix.meta.rsrcs
        $scope.res_tags = [];   // ^^ Defines the order of rows
        $scope.rsrcs.forEach( function(rsrc) {
          $scope.res_tags.push( rsrc.tag )
        })
        $scope.use_block_list_Ctls = {} // To access lower-level scopes later on

        setTimeout( TimePix.scroll_to_tlo, 100 )
        setTimeout( TimePix.set_time_cursor, 1000 )
        setTimeout( TimePix.scroll_monitor, 100 )
      },

      get_data: function (t1, t2, inc) {
        return $http.get( $scope.make_url(t1, t2, inc) ).

          success( function(data) {
            TimePix.merge_metadata(data)
            delete data.meta
            $scope.json_data = data   // Park this here until we consume it.

            if (! inc) { $scope.init_resources($scope) }
            $scope.busy = false;
          }). // success

          error( function(data, status, headers, config) {
            console.log( '\nstatus: ' + status +
                         '\nheaders(): ' + headers() +
                         '\nconfig: ' + config
                        )
            console.debug( data.meta )
            $scope.busy = false;
          }) // error
      },

      make_url: function (t1, t2, inc) {
        var url = '/schedule.json'
        if (t1 || t2 || inc)
          url += '?t1=' + t1 + '&t2=' + t2 + '&inc=' + inc
        return url
      },

      rq_data: function(t1, t2, inc) {
        if (! $scope.busy ) {
          $scope.busy = true;
          $scope.get_data( t1, t2, inc ).
            success( function(data) {
              Object.keys($scope.json_data).forEach( function(key) {
                var controller = $scope.use_block_list_Ctls[key] // To Do: Better mis-configuration response
                if( ! controller ) {
                  console.log( "No key " + key + " in " +
                               $scope.use_block_list_Ctls );
                  return
                }
                var blocks     = $scope.json_data[key]
                controller.add_blocks( controller, blocks ) // To Do: Better mis-configuration response
              })

            }); // errors handled above in get_data
        }
      },
      
      more_data: function() {
          $scope.rq_data( TimePix.thi, TimePix.next_hi(), 'hi' )
      },

      less_data: function() {
          $scope.rq_data( TimePix.next_lo(), TimePix.tlo, 'lo' )
      }
    });
  window.RsrcListCtrlScope = $scope;
  $scope.get_data();
} // end ResourceListCtrl
ResourceListCtrl.$inject = ['$scope', '$http'];


function ab (o) { return angular.bind( o, o.process ) }

var process_fns = {
  Station:            ab(StationUseBlock),
  ZTimeHeaderDay:     ab(ZTimeHeaderDayUseBlock),
  ZTimeHeaderHour:    ab(ZTimeHeaderHourUseBlock)
}


function UseBlockListCtrl($scope) {

  $.extend( $scope, {

    add_blocks: function ( $scope, blocks ) {
      var how = 'push'
      if (TimePix.inc == 'lo') {
        how = 'unshift'
        blocks.reverse()
      }
      if( ! blocks ) { return }         // Why bother with this?
      blocks.forEach( function(block) {
        $scope.insert_block( $scope.process_fn(block.blk), how )
      })
    },

    insert_block: function ( block, how ) {
      $scope.use_blocks[how]( block )
    }
  });


  $scope.use_blocks = [];

  var resourceTag = $scope.res_tag,
      blocks      = $scope.json_data[ resourceTag ],
      rsrc_kind   = resourceTag.split('_')[0];

  $scope.process_fn = process_fns[rsrc_kind];
  if (! $scope.process_fn) {
    console.log( 'Skipping use blocks with tag ' + resourceTag + ', Kind ' + rsrc_kind )
    return null
  }

  $scope.use_block_list_Ctls[resourceTag] = $scope

  $scope.add_blocks( $scope, blocks )
}
UseBlockListCtrl.$inject = ['$scope'];


function UseBlockCtrl($scope) {
  var block = $scope.block // Just for debugger
}
UseBlockCtrl.$inject = ['$scope'];


function LabelListCtrl($scope) {
  var tag = $scope.res_tag
  UseBlock.rsrcs[tag] // (?)
}
LabelListCtrl.$inject = ['$scope'];

