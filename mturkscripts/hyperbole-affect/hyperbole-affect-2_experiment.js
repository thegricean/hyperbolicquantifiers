var NUM_SLIDERS = 7;

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function showSlide(id) {
  $(".slide").hide();
  $("#"+id).show();
}

function random(a,b) {
  if (typeof b == "undefined") {
    a = a || 2;
    return Math.floor(Math.random()*a);
  } else {
    return Math.floor(Math.random()*(b-a+1)) + a;
  }
}

function shuffle(array) {
  var currentIndex = array.length
    , temporaryValue
    , randomIndex
    ;

  // While there remain elements to shuffle...
  while (0 !== currentIndex) {

    // Pick a remaining element...
    randomIndex = Math.floor(Math.random() * currentIndex);
    currentIndex -= 1;

    // And swap it with the current element.
    temporaryValue = array[currentIndex];
    array[currentIndex] = array[randomIndex];
    array[randomIndex] = temporaryValue;
  }

  return array;
}

function clearForm(oForm) {
  var sliderVar = "";
  for(var i=0; i<NUM_SLIDERS; i++)
  {
    sliderVar = "#slider" + i;
    $(sliderVar).slider("value", 20);
    $(sliderVar).css({"background":"#FFFFFF"});
    $(sliderVar + " .ui-slider-handle").css({
        "background":"#FAFAFA",
        "border-color": "#CCCCCC" });
    sliderVar = "slider" + i;
    document.getElementById(sliderVar).style.background = "";
  }
  
  var elements = oForm.elements; 
  
  oForm.reset();

  for(var i=0; i<elements.length; i++) {
    field_type = elements[i].type.toLowerCase();
    switch(field_type) {
    
      case "text": 
      case "password": 
      case "textarea":
            case "hidden":  
        
        elements[i].value = ""; 
        break;
          
      case "radio":
      case "checkbox":
          if (elements[i].checked) {
            elements[i].checked = false; 
        }
        break;
  
      case "select-one":
      case "select-multi":
                  elements[i].selectedIndex = -1;
        break;
  
      default: 
        break;
    }
  }
}

Array.prototype.random = function() {
  return this[random(this.length)];
}

function setQuestion(array) {
    var i = random(0, array.length - 1);
    var q = array[i];
    return q;
}

function shuffledArray(arrLength)
{
  var j, tmp;
  var arr = new Array(arrLength);
  for (i = 0; i < arrLength; i++)
  {
    arr[i] = i;
  }
  for (i = 0; i < arrLength-1; i++)
  {
    j = Math.floor((Math.random() * (arrLength - 1 - i)) + 0.99) + i;
    tmp = arr[i];
    arr[i] = arr[j];
    arr[j] = tmp;
  }
  return arr;
}

function shuffledSampleArray(arrLength, sampleLength)
{
  var arr = shuffledArray(arrLength);
  var beginIndex = Math.floor(Math.random() * (arrLength-sampleLength+1));
  return arr.slice(beginIndex, beginIndex+sampleLength);
}

function getRadioCheckedValue(formNum, radio_name)
{
   var oRadio = document.forms[formNum].elements[radio_name];
   for(var i = 0; i < oRadio.length; i++)
   {
      if(oRadio[i].checked)
      {
         return oRadio[i].value;
      }
   }
   return '';
}

function randomizeSharpOffset()
{
  
  var r = Math.floor((Math.random()*6)+1);
  if (r < 4) { return r; }
  else { return 3-r; }
  /*
  var r = Math.floor((Math.random()*3)+1);
  return r;
  */
}

//var quantifiersArray = ["some", "all"];

var foodTypes = ["blueberries", "M&M's", "strawberries", "cookies", "bananas", "pies"];
var allConditions = 
[
[
{"totalQuant": 10, "eatenQuant":3, "quantifier": "all", "condition": "hyperbolic"},
{"totalQuant": 10, "eatenQuant":8, "quantifier": "all", "condition": "hyperbolic"},
{"totalQuant": 10, "eatenQuant":10, "quantifier": "all", "condition": "true-all"},
{"totalQuant": 10, "eatenQuant":3, "quantifier": "some", "condition": "true-some"},
{"totalQuant": 10, "eatenQuant":8, "quantifier": "some", "condition": "true-some"},
{"totalQuant": 10, "eatenQuant":10, "quantifier": "some", "condition": "literal-some"},
{"totalQuant": 100, "eatenQuant":3, "quantifier": "all", "condition": "hyperbolic"},
{"totalQuant": 100, "eatenQuant":8, "quantifier": "all", "condition": "hyperbolic"},
{"totalQuant": 100, "eatenQuant":10, "quantifier": "all", "condition": "true-all"},
{"totalQuant": 100, "eatenQuant":3, "quantifier": "some", "condition": "true-some"},
{"totalQuant": 100, "eatenQuant":8, "quantifier": "some", "condition": "true-some"},
{"totalQuant": 100, "eatenQuant":10, "quantifier": "some", "condition": "literal-some"},
]
];

var allNames = ["Ann", "Barbara", "Cathy", "Diana", "Emma", "Fiona", "Grace", "Heather", "Iris", "Jane", "Kathy",
"Lena", "Mary", "Nancy", "Olga", "Patty", "Rebecca", "Stephanie", "Tracy", "Victoria", "Wendy", "Yvonne", 
"Albert", "Bob", "Calvin", "David", "Edward", "Frank", "George", "Henry", "Ivan", "Jake", "Kevin", "Larry",
"Matt", "Nathan", "Oliver", "Patrick", "Robert", "Steven", "Tom", "Victor", "Winston", "Zack"];

var girlNames = ["Ann", "Barbara", "Cathy", "Diana", "Emma", "Fiona", "Grace", "Heather", "Iris", "Jane", "Kathy",
"Lena", "Mary", "Nancy", "Olga", "Patty", "Rebecca", "Stephanie", "Tracy", "Victoria", "Wendy", "Yvonne"];

var boyNames = ["Albert", "Bob", "Calvin", "David", "Edward", "Frank", "George", "Henry", "Ivan", "Jake", "Kevin", "Larry",
"Matt", "Nathan", "Oliver", "Patrick", "Robert", "Steven", "Tom", "Victor", "Winston", "Zack"];

var allAffects = ["upset", "annoyed", "angry", "disgusted", "excited", "happy", "surprised"];
var shuffledAffects;

var debug = false;
if(debug) { allConditions = debugConditions; }

var numConditions = allConditions.length;
var chooseCondition = random(0, numConditions-1);
var allTrialOrders = allConditions[chooseCondition];
var numTrials = allTrialOrders.length;
var shuffledOrder = shuffledSampleArray(allTrialOrders.length, numTrials);
var currentTrialNum = 0;
var trial;
var numComplete = 0;
allNames = shuffle(allNames);
showSlide("instructions");
$("#trial-num").html(numComplete);
$("#total-num").html(numTrials);


var experiment = {
  condition: chooseCondition + 1,
  foods: new Array(numTrials),
  totalQuants: new Array(numTrials),
  eatenQuants: new Array(numTrials),
  preciseEatenQuants: new Array(numTrials),
  quantifiers: new Array(numTrials),
  conditions: new Array(numTrials),

  upset: new Array(numTrials),
  annoyed: new Array(numTrials),
  angry: new Array(numTrials),
  disgusted: new Array(numTrials),
  excited: new Array(numTrials),
  happy: new Array(numTrials),
  surprised: new Array(numTrials),


  orders: new Array(numTrials),
  personAs: new Array(numTrials),
  personBs: new Array(numTrials),
  gender: "",
  age:"",
  income:"",
  nativeLanguage:"",
  comments:"",

  description: function() {
    showSlide("description");
    $("#tot-num").html(numTrials);  
  },
  end: function() {
    var gen = getRadioCheckedValue(1, "genderButton");
    var ag = document.age.ageRange.value;
    var lan = document.language.nativeLanguage.value;
    var comm = document.comments.input.value;
    var incomeVal = document.income.incomeRange.value;
    experiment.gender = gen;
    experiment.age = ag;
    experiment.nativeLanguage = lan;
    experiment.comments = comm;
    experiment.income = incomeVal;
    clearForm(document.forms[1]);
    clearForm(document.forms[2]);
    clearForm(document.forms[3]);
    clearForm(document.forms[4]);
    clearForm(document.forms[5]);    
    showSlide("finished");
    setTimeout(function() {turk.submit(experiment) }, 1500);
  },
  next: function() {
    if (numComplete > 0) {
      //var price = 0;//parseFloat(document.price.score.value) + parseFloat(document.price.score1.value) / 100.00;
      
      //var probAffect0 = parseInt(document.getElementById("hiddenSliderValue0").value) / 40.00;

      experiment.upset[currentTrialNum] = parseInt(document.getElementById("hiddenSliderValue".concat(shuffledAffects.indexOf("upset"))).value) / 40.00;
      experiment.angry[currentTrialNum] = parseInt(document.getElementById("hiddenSliderValue".concat(shuffledAffects.indexOf("angry"))).value) / 40.00;
      experiment.annoyed[currentTrialNum] = parseInt(document.getElementById("hiddenSliderValue".concat(shuffledAffects.indexOf("annoyed"))).value) / 40.00;
      experiment.disgusted[currentTrialNum] = parseInt(document.getElementById("hiddenSliderValue".concat(shuffledAffects.indexOf("disgusted"))).value) / 40.00;
      experiment.happy[currentTrialNum] = parseInt(document.getElementById("hiddenSliderValue".concat(shuffledAffects.indexOf("happy"))).value) / 40.00;
      experiment.excited[currentTrialNum] = parseInt(document.getElementById("hiddenSliderValue".concat(shuffledAffects.indexOf("excited"))).value) / 40.00;
      experiment.surprised[currentTrialNum] = parseInt(document.getElementById("hiddenSliderValue".concat(shuffledAffects.indexOf("surprised"))).value) / 40.00;
      
      experiment.orders[currentTrialNum] = numComplete;
      //experiment.preciseEatenQuants[currentTrialNum] = document.getElementById("preciseEatenQuant").innerHTML;
          
      clearForm(document.forms[0]);
      //clearForm(document.forms[1]);
    }
    if (numComplete >= numTrials) {
      $('.bar').css('width', (200.0 * numComplete/numTrials) + 'px');
      $("#trial-num").html(numComplete);
      $("#total-num").html(numTrials);
      showSlide("askInfo");
    } else {
      $('.bar').css('width', (200.0 * numComplete/numTrials) + 'px');
      $("#trial-num").html(numComplete);
      $("#total-num").html(numTrials);
      currentTrialNum = numComplete;

      trial = allTrialOrders[shuffledOrder[numComplete]];
      personA = allNames.shift();
      personB = allNames.shift();

      if (girlNames.indexOf(personA) >= 0) {
        pronoun = "She";
      } else {
        pronoun = "He";
      }

      quantifier = trial.quantifier;
      food = foodTypes.random();
      totalQuant = trial.totalQuant;

      experiment.personAs[numComplete] = personA;
      experiment.personBs[numComplete] = personB;
      experiment.foods[numComplete] = food;

      experiment.totalQuants[numComplete] = totalQuant;
      experiment.eatenQuants[numComplete] = trial.eatenQuant;
      experiment.quantifiers[numComplete] = quantifier;
      experiment.conditions[numComplete] = trial.condition;

      showSlide("stage");

      $("#personA1").html(personA);
      $("#personA2").html(personA);
      $("#personA3").html(personA);
      $("#personA4").html(personA);
      $("#personB1").html(personB);
      $("#personB2").html(personB);
      $("#personB3").html(personB);
      $("#personB4").html(personB);
      $("#pronoun").html(pronoun);
      $("#totalQuantity").html(totalQuant);
      $("#quantifier").html(quantifier);
      if (totalQuant == 10) {
        var preciseEatenQuant = trial.eatenQuant;
      } else if (trial.eatenQuant == 10) {
        var preciseEatenQuant = 100;
      } else {
        var preciseEatenQuant = trial.eatenQuant * 10 + random(0, 9);
      }
      $("#eatenQuantity").html(preciseEatenQuant);
      experiment.preciseEatenQuants[numComplete] = preciseEatenQuant;
      $("#food1").html(food);
      $("#food2").html(food);

      shuffledAffects = shuffle(allAffects);
      for (var i=0; i < NUM_SLIDERS; i++) {
        $("#affect".concat(i)).html(shuffledAffects[i])
      }
      
      //var utteredSliderIndexName = "#cost" + currentUtteredPriceSliderIndex;
      //$(utteredSliderIndexName).html(numberWithCommas(currentUtteredPrice));
      numComplete++;
    }
  }
}

$("#slider0").slider({
               animate: true,
               
               max: 40 , min: 0, step: 1, value: 20,
               slide: function( event, ui ) {
                   $("#slider0 .ui-slider-handle").css({
                      "background":"#E0F5FF",
                      "border-color": "#001F29"
                   });
               },
               change: function( event, ui ) {
                   $('#hiddenSliderValue0').attr('value', ui.value);
                   $("#slider0").css({"background":"#99D6EB"});
                   $("#slider0 .ui-slider-handle").css({
                     "background":"#667D94",
                     "border-color": "#001F29" });
               }});

$("#slider1").slider({
               animate: true,
               
               max: 40 , min: 0, step: 1, value: 20,
               slide: function( event, ui ) {
                   $("#slider1 .ui-slider-handle").css({
                      "background":"#E0F5FF",
                      "border-color": "#001F29"
                   });
               },
               change: function( event, ui ) {
                   $('#hiddenSliderValue1').attr('value', ui.value);
                   $("#slider1").css({"background":"#99D6EB"});
                   $("#slider1 .ui-slider-handle").css({
                     "background":"#667D94",
                     "border-color": "#001F29" });
               }});
$("#slider2").slider({
               animate: true,
               
               max: 40 , min: 0, step: 1, value: 20,
               slide: function( event, ui ) {
                   $("#slider2 .ui-slider-handle").css({
                      "background":"#E0F5FF",
                      "border-color": "#001F29"
                   });
               },
               change: function( event, ui ) {
                   $('#hiddenSliderValue2').attr('value', ui.value);
                   $("#slider2").css({"background":"#99D6EB"});
                   $("#slider2 .ui-slider-handle").css({
                     "background":"#667D94",
                     "border-color": "#001F29" });
               }});
$("#slider3").slider({
               animate: true,
               
               max: 40 , min: 0, step: 1, value: 20,
               slide: function( event, ui ) {
                   $("#slider3 .ui-slider-handle").css({
                      "background":"#E0F5FF",
                      "border-color": "#001F29"
                   });
               },
               change: function( event, ui ) {
                   $('#hiddenSliderValue3').attr('value', ui.value);
                   $("#slider3").css({"background":"#99D6EB"});
                   $("#slider3 .ui-slider-handle").css({
                     "background":"#667D94",
                     "border-color": "#001F29" });
               }});
$("#slider4").slider({
               animate: true,
               
               max: 40 , min: 0, step: 1, value: 20,
               slide: function( event, ui ) {
                   $("#slider4 .ui-slider-handle").css({
                      "background":"#E0F5FF",
                      "border-color": "#001F29"
                   });
               },
               change: function( event, ui ) {
                   $('#hiddenSliderValue4').attr('value', ui.value);
                   $("#slider4").css({"background":"#99D6EB"});
                   $("#slider4 .ui-slider-handle").css({
                     "background":"#667D94",
                     "border-color": "#001F29" });
               }});
$("#slider5").slider({
               animate: true,
               
               max: 40 , min: 0, step: 1, value: 20,
               slide: function( event, ui ) {
                   $("#slider5 .ui-slider-handle").css({
                      "background":"#E0F5FF",
                      "border-color": "#001F29"
                   });
               },
               change: function( event, ui ) {
                   $('#hiddenSliderValue5').attr('value', ui.value);
                   $("#slider5").css({"background":"#99D6EB"});
                   $("#slider5 .ui-slider-handle").css({
                     "background":"#667D94",
                     "border-color": "#001F29" });
               }});
$("#slider6").slider({
               animate: true,
               
               max: 40 , min: 0, step: 1, value: 20,
               slide: function( event, ui ) {
                   $("#slider6 .ui-slider-handle").css({
                      "background":"#E0F5FF",
                      "border-color": "#001F29"
                   });
               },
               change: function( event, ui ) {
                   $('#hiddenSliderValue6').attr('value', ui.value);
                   $("#slider6").css({"background":"#99D6EB"});
                   $("#slider6 .ui-slider-handle").css({
                     "background":"#667D94",
                     "border-color": "#001F29" });
               }});



