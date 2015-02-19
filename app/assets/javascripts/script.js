// declare a module
var srAppModule = angular.module('srApp', []);
 
// Configure the module.  Create some filters.
srAppModule.filter('style_geo', function() {
  return angular.bind(TimePix, TimePix.style_geo);
});

srAppModule.filter('rowKind', function() {
  return angular.bind(TimePix, TimePix.row_kind);
});
