// run the code in: https://code.earthengine.google.com/
// documentation for the dataset: https://developers.google.com/earth-engine/datasets/catalog/JAXA_GPM_L3_GSMaP_v6_reanalysis

// lat, lon
var locations = {
  "Annapurna": [28.56666667, 83.83333333],
  "Arun": [26.91666667, 87.16666667],
  "Baitadi": [29.58333333, 80.41666667],
  "Bhaktapur": [27.63333333, 85.4],
  "Birantnagar": [26.45, 87.28333333],
  "Chisapani Garhi": [27.5, 84.03333333],
  "Dandeldhura": [29.33333333, 80.58333333],
  "Dhangarhi": [28.91666667, 80.66666667],
  "Dhankuta": [26.91666667, 87.66666667],
  "Dhaulagiri": [28.65, 83.46666667],
  "Everest Mt": [28.08333333, 86.96666667],
  "Gurkha": [28.08333333, 84.66666667],
  "Ilam": [26.96666667, 87.96666667],
  "Jaleswar": [26.63333333, 85.8],
  "Jumla": [29.25, 82.21666667],
  "Kanchenjunga": [27.83333333, 88.16666667],
  "Karnali": [28.75, 81.26666667],
  "Kathmandu(Katmandu)": [27.75, 85.33333333],
  "Katmandu": [27.75, 85.33333333],
  "Lalitapur": [27.66666667, 85.33333333],
  "Mahabharat Lekh": [28.5, 82],
  "Manaslu": [28.55, 84.55],
  "Mugu": [29.75, 82.5],
  "Mustang": [29.16666667, 83.91666667],
  "Namche Bazar": [27.85, 86.78333333],
  "Nawakot": [27.91666667, 85.16666667],
  "Nepalganj": [28.08333333, 81.66666667],
  "Nuwakot": [28.16666667, 83.91666667],
  "Patan(Lalitapur)": [27.66666667, 85.33333333],
  "Pokhara": [28.23333333, 83.96666667],
  "Ramechhap": [27.41666667, 86.16666667],
  "Silgarhi Doti": [29.25, 81],
  "Smimikot": [30, 81.83333333],
  "Siwalik Range": [28, 83],
  "Udaipur Garhi": [27, 86.56666667]
};

// loop through locations
for (var locationName in locations) {
  
  var loc = locations[locationName];
  var Elv = ee.Geometry.Point(loc[1],loc[0]);  // lon, lat
  // Map.addLayer(Elv, {}, 'Nepal')
  
  // load in data and select dates 
  var PRECIP = ee.ImageCollection("JAXA/GPM_L3/GSMaP/v6/operational")   
                   .filterDate('2018-04-01','2023-04-01');
  
  // print(PRECIP);
  
  var getPrecipit = function(image) {
    
    var time = ee.Date(ee.Image(image).get('system:time_start')).format(); 
    
    var value_precipt = ee.Image(image)
      .reduceRegion(ee.Reducer.first(), Elv)
      .get('hourlyPrecipRate');
      
    return [time, value_precipt];
    
  };
  
  var count = PRECIP.size();
  
  // print("Number of values", count);
  
  var precipit_list = PRECIP.toList(count).map(getPrecipit);
  
  // print(precipit_list);
  
  var myFeatures = ee.FeatureCollection(precipit_list.map(function(el){
    el = ee.List(el); // cast every element of the list
    var geom = Elv;
    return ee.Feature(geom, {
      'date': ee.String(el.get(0)),
      'value':ee.Number(el.get(1))
    });
  }));
  
  // print(myFeatures);
  
  // Export features, specifying corresponding names.
  Export.table.toDrive(myFeatures,
    locationName, //my task
  "Nepal", //my export folder
  locationName,  //file name
  "CSV");
  
};