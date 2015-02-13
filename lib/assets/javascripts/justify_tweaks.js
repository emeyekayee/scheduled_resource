'use strict';

// ============================================================================
// Hi-lock: ((" ?[T]o ?Do:.*"                                  (0 'accent10 t)))
// Hi-lock: (("\\(^\\|\\W\\)\\*\\(\\w.*\\w\\)\\*\\(\\W\\|$\\)" (2 'accent3 t)))
// Hi-lock: end
// ============================================================================

// The idea here is to have *smooth* horizontal scrolling for a mobile device,
// track-pad or touch-sensitive mouse like Apple's.  It makes navigating a
// time-window feel much more natural.
//
// If you have text within the scrolled content you may want to re-justify that
// text for readability as it scrolls left or right.
//
// This is one approach that avoids the jerkiness associated with a normal
// scroll event-listener.  The idea is just to wait for the scroll position to
// stabilize, recalculate the visible parts of each container, then animate
// changes to the '.text_locator' with a little randomness thrown in.

// ToDo: Convert this to an object w/ methods, for better encapsulation.
 
// Sole exported function: 
function filter_justify_tweaks(sc) {
  var scrollLeft  = sc.scrollLeft()

  // Don't repeat the calculation unnecessarily....
  if ( filter_justify_tweaks.old_srcoll == scrollLeft ) return
  filter_justify_tweaks.old_srcoll = scrollLeft 

  do_justify_tweaks( sc, scrollLeft )
}


function do_justify_tweaks (sc, scrollLeft) {
  $('.ZTimeHeaderDayrow .timespan').each( function() { // Centered
    justify( scrollLeft, $(this).children() )
  });

  $('.Stationrow .timespan').each( function() {        // Left-aligned
    justify_left( scrollLeft, $(this).children() )
  });

}


function may_straddle (scrollLeft, scrollRight, blockdivs) {
  var divs = [], bdiv, cd;
  var len = blockdivs.length;

  for (var i = 0;
       (i<len) && (cd = common_data(blockdivs[i])) && cd.bdiv_right < scrollLeft;
       i++) {}

  for (;
       (i<len) && (bdiv= blockdivs[i]) && parseInt(bdiv.style.left) < scrollRight;
       i++) {
    divs.push( bdiv )
  }
  return divs
}

// function sort_em (divs) {
//   divs.sort( function(a, b) {
//     return parseInt(a.style.left) - parseInt(b.style.left)
//   })
// }


//////////////////////////////////////////////////////////////////////////////
// Re-align left-aligned block content (typ. Channelrows)

function justify_left (scrollLeft, blockdivs) {
  // sort_em( blockdivs )

  var scrollRight = scrollLeft + TimePix.pixWindow,
      bdivs       = may_straddle (scrollLeft, scrollRight, blockdivs);
  if (! bdivs.length) {return}

  var cd = common_data( bdivs[0] )
  if ( cd.bdiv_left < scrollLeft  ) {
    bdivs.shift()
    justify_left_1 ( scrollLeft,  cd );
  }
  undo_any_justify_left( bdivs );
}

function justify_left_1 ( scrollLeft, cd ) {
  if ( cd.bdiv_left + cd.bdiv_width > scrollLeft ) {
    var jleft  = scrollLeft - cd.bdiv_left

    // cd.tl.css('left', jleft + 'px')
    cd.tl.animate({left: jleft}, rand_speed())
  }
}

function undo_any_justify_left (bdivs) {
  bdivs.forEach( function( bdiv ) {
    // $('.text_locator', bdiv).css( 'left', '')
    var tl = $('.text_locator', bdiv)
    if ( parseInt(tl.css('left')) == 2 ) {return}
    tl.animate({ left: "2" }, rand_speed())
  })
}

function rand_speed() { return { duration: 200 + Math.random() * 800 } }

//////////////////////////////////////////////////////////////////////////////
// Re-align center-aligned block content.

function justify (scrollLeft, blockdivs) {
  // sort_em(blockdivs)
  var scrollRight = scrollLeft + TimePix.pixWindow,
      bdivs       = may_straddle (scrollLeft, scrollRight, blockdivs);
  if (! bdivs.length) {return}


  if ( straddles(scrollLeft, bdivs[0]) && straddles(scrollRight, bdivs[0]) ) {
    straddles_both( scrollLeft, scrollRight, common_data(bdivs[0]) )
  } else {

    while ( bdivs.length > 0 && straddles( scrollLeft, bdivs[0] ) ) {
      straddles_left  (scrollLeft,  common_data(bdivs.shift()));
    }

    while ( bdivs.length > 0 && straddles( scrollRight, bdivs.slice(-1)[0] ) ) {
      straddles_right( scrollRight, common_data(bdivs.pop()) );
    }

    bdivs.forEach( function(bdiv) {
      straddles_none(               common_data(bdiv));
    })
  }
}

function straddles(edge, bdiv) {
  var cd = common_data( bdiv )
  return ( cd.bdiv_left < edge && edge < cd.bdiv_right )
}

function common_data(bdiv) {
  var left  = parseInt(bdiv.style.left)
  var width = parseInt(bdiv.style.width)
  return { tl:         $('.text_locator', bdiv),
           bdiv_left:  left,
           bdiv_width: width,
           bdiv_right: left + width }
}

function straddles_both (scrollLeft, scrollRight, cd) {
  var  nleft = scrollLeft  - cd.bdiv_left
  var nwidth = scrollRight - scrollLeft
  relocate (cd.tl,  nleft, nwidth)
}

function straddles_right (scrollRight, cd) {
  if ( cd.bdiv_left + cd.bdiv_width > scrollRight ) {
    var room = scrollRight - parseInt( cd.tl.parent().css('left') )
    var jwidth = Math.max( room, 190 ) // 15 in vp
    relocate (cd.tl,     0, jwidth)
  }
}

function straddles_left (scrollLeft, cd) {
  if ( cd.bdiv_left + cd.bdiv_width > scrollLeft ) {
    var room = parseInt( cd.tl.parent().css('width') )
    var jleft  = Math.min (scrollLeft - cd.bdiv_left, room - 190 ) // 15 in vp
    var jwidth = room - jleft           // Should calculate  ^^^ this Fix Me
    relocate (cd.tl, jleft, jwidth)
  }
}

function straddles_none(cd) {
  var room = parseInt( cd.tl.parent().css('width') )
  if ( parseInt(cd.tl.css('left'))  != 0 ||
       parseInt(cd.tl.css('width')) != room ) {
    relocate (cd.tl,    0, room)
  }
}


function relocate (tl, nleft, nwidth) {
  tl.animate({opacity: 0}, {queue: true, duration: 200})
  tl.animate({ left: nleft, width: nwidth}, {queue: true, duration: 0})
  tl.animate({opacity: 1}, {queue: true, duration: 800})
}
