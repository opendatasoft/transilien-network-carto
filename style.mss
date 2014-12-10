/* ******* */
/* Palette */
/* ******* */
@water:             #bed9e0;
@land:              #fefefd;
@water:             #90cccb;
@grass:             #d3e0be;
@admin:             #c7a28a;

@rail_line:         #999;
@rail_fill:         #efefef;
@rail_case:         #444;

@city_text:         #222;
@city_halo:         @land;
@town_text:         #444;
@town_halo:         @land;
@village_text:      #444;
@village_halo:      @land;

@sans:              'PT Sans Regular';
@sans_bold:         'PT Sans Bold';
@sans_bold_italic:  'PT Sans Bold Italic';


/* *********** */
/* backgrounds */
/* *********** */

Map {
  background-color: @water;
  buffer-size: 256;
}
#land {
  polygon-fill: @land;
}
#landuse[type='park']          { polygon-fill: @grass; }
#landuse[type='garden']        { polygon-fill: @grass; }
#landuse[type='forest']        { polygon-fill: @grass;}
#landuse[type='wood']          { polygon-fill: @grass; }

#waterway {
  polygon-fill: @water;
}

/* ************************* */
/* ADMINISTRATIVE BOUNDARIES */
/* ************************* */
#boundary[admin_level=4],
#boundary[admin_level=6],
#boundary[admin_level=8][zoom>=12],
#boundary[admin_level=9][zoom>=12] {
  eraser/line-color: white;
  eraser/line-width: 0.5;
  eraser/comp-op: darken;
  line-color: @admin;
  line-width: 0.5;
  line-smooth: 0.2;
  [zoom<12] {
    line-simplify: 10;
  }
  [admin_level=8],
  [admin_level=9] {
    line-dasharray: 1,3;
    line-cap: round;
    line-color: darken(@admin, 10%);
  }
  [admin_level=4] {
    line-color: darken(@admin, 10%);
    line-cap: butt;
    line-color: @admin;
    line-width: 1;
    line-dasharray: 10,4,2,4;
    [zoom>=12] {
      line-width: 2;
    }
  }
}

/* ******** */
/* RAILWAYS */
/* ******** */
#railway[zoom<12] {
  line-color: @rail_case;
  line-width: 1;
}
#railway[zoom>=12] {
  outline/line-color: @rail_case;
  outline/line-width: 2.4;
  outline/line-cap: square;
  line-color: @rail_fill;
  line-width: 2;
  line-dasharray: 5,5;
  [zoom>=14] {
    outline/line-width: 3;
    line-width: 2;
    line-dasharray: 7,5;
  }
}


/* ****** */
/* LABELS */
/* ****** */
#place[type='city'][name='Paris'] {
  text-name:'[name]';
  text-size: 14;
  text-face-name: @sans_bold_italic;
  text-transform: uppercase;
  text-halo-radius: 2;
  text-fill: @city_text;
  text-halo-fill: @city_halo;
}
#place[type='town'],
#place[type='village'][zoom>=12] {
  text-name:'[name].replace("Saint-", "St-").replace("Sainte-", "Ste-")';
  text-face-name: @sans_bold;
  text-placement:point;
  text-fill: @town_text;
  text-size: 10;
  text-halo-fill: @town_halo;
  text-halo-radius: 2;
  text-wrap-width: 30;
  text-label-position-tolerance: 10;
  text-character-spacing: 0.1;
  text-wrap-width: 30;
  text-wrap-character: '-';
  text-repeat-wrap-character: true;  // mapnik 3.x only
  text-line-spacing: -2;
  text-min-padding: 1;
  [zoom<12] {text-min-distance: 10;}
  [zoom=11] {text-size: 11;}
  [zoom=12] {text-size: 12;}
  [zoom=13] {text-size: 14;}
  [zoom>=14] {text-size: 15;}
}
