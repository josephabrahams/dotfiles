/* jshint strict: false */
/* global slate */

/*!
 * Slate js configuration file
 * ~/.slate overrides any bindings found here
 *
 * See http://joseph.is/1H379Dp
 */

var hyper = ':ctrl,alt,cmd,shift';


/**
 * Spotify bindings
 * Based on http://joseph.is/1bN3nVc
 */

// Spotify toggle
slate.bind('space'+hyper, function() {
  slate.shell('/usr/bin/osascript -e \'tell application "Spotify" to playpause\'');
}, false);

// Spotify previous
slate.bind(';'+hyper, function() {
  slate.shell('/usr/bin/osascript -e \'tell application "Spotify" to previous track\'');
}, false);

// Spotify next
slate.bind('\''+hyper, function() {
  slate.shell('/usr/bin/osascript -e \'tell application "Spotify" to next track\'');
}, false);

