var NUM_SLIDERS = 0;

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
var totalQuants = [10, 100];
var allConditions = 
[
[
{"eatenQuant":7, "quantifier": "all", "condition": "hyperbolic"},
{"eatenQuant":8, "quantifier": "all", "condition": "hyperbolic"},
{"eatenQuant":9, "quantifier": "all", "condition": "hyperbolic"},
{"eatenQuant":10, "quantifier": "all", "condition": "true-all"},
{"eatenQuant":10, "quantifier": "some", "condition": "literal-some"},
{"eatenQuant":0, "quantifier": "all", "condition": "ironic"},
{"eatenQuant":3, "quantifier": "some", "condition": "true-some"},

/*
{"food":"blueberries", "totalQuant": 10, "eatenQuant":0},
{"food":"blueberries", "totalQuant": 10, "eatenQuant":1},
{"food":"blueberries", "totalQuant": 10, "eatenQuant":2},
{"food":"blueberries", "totalQuant": 10, "eatenQuant":3},
{"food":"blueberries", "totalQuant": 10, "eatenQuant":4},
{"food":"blueberries", "totalQuant": 10, "eatenQuant":5},
{"food":"blueberries", "totalQuant": 10, "eatenQuant":6},
{"food":"blueberries", "totalQuant": 10, "eatenQuant":7},
{"food":"blueberries", "totalQuant": 10, "eatenQuant":8},
{"food":"blueberries", "totalQuant": 10, "eatenQuant":9},
{"food":"blueberries", "totalQuant": 10, "eatenQuant":10},
{"food":"blueberries", "totalQuant": 100, "eatenQuant":0},
{"food":"blueberries", "totalQuant": 100, "eatenQuant":1},
{"food":"blueberries", "totalQuant": 100, "eatenQuant":2},
{"food":"blueberries", "totalQuant": 100, "eatenQuant":3},
{"food":"blueberries", "totalQuant": 100, "eatenQuant":4},
{"food":"blueberries", "totalQuant": 100, "eatenQuant":5},
{"food":"blueberries", "totalQuant": 100, "eatenQuant":6},
{"food":"blueberries", "totalQuant": 100, "eatenQuant":7},
{"food":"blueberries", "totalQuant": 100, "eatenQuant":8},
{"food":"blueberries", "totalQuant": 100, "eatenQuant":9},
{"food":"blueberries", "totalQuant": 100, "eatenQuant":10},
{"food":"M&M's", "totalQuant": 10, "eatenQuant":0},
{"food":"M&M's", "totalQuant": 10, "eatenQuant":1},
{"food":"M&M's", "totalQuant": 10, "eatenQuant":2},
{"food":"M&M's", "totalQuant": 10, "eatenQuant":3},
{"food":"M&M's", "totalQuant": 10, "eatenQuant":4},
{"food":"M&M's", "totalQuant": 10, "eatenQuant":5},
{"food":"M&M's", "totalQuant": 10, "eatenQuant":6},
{"food":"M&M's", "totalQuant": 10, "eatenQuant":7},
{"food":"M&M's", "totalQuant": 10, "eatenQuant":8},
{"food":"M&M's", "totalQuant": 10, "eatenQuant":9},
{"food":"M&M's", "totalQuant": 10, "eatenQuant":10},
{"food":"M&M's", "totalQuant": 100, "eatenQuant":0},
{"food":"M&M's", "totalQuant": 100, "eatenQuant":1},
{"food":"M&M's", "totalQuant": 100, "eatenQuant":2},
{"food":"M&M's", "totalQuant": 100, "eatenQuant":3},
{"food":"M&M's", "totalQuant": 100, "eatenQuant":4},
{"food":"M&M's", "totalQuant": 100, "eatenQuant":5},
{"food":"M&M's", "totalQuant": 100, "eatenQuant":6},
{"food":"M&M's", "totalQuant": 100, "eatenQuant":7},
{"food":"M&M's", "totalQuant": 100, "eatenQuant":8},
{"food":"M&M's", "totalQuant": 100, "eatenQuant":9},
{"food":"M&M's", "totalQuant": 100, "eatenQuant":10},
{"food":"strawberries", "totalQuant": 10, "eatenQuant":0},
{"food":"strawberries", "totalQuant": 10, "eatenQuant":1},
{"food":"strawberries", "totalQuant": 10, "eatenQuant":2},
{"food":"strawberries", "totalQuant": 10, "eatenQuant":3},
{"food":"strawberries", "totalQuant": 10, "eatenQuant":4},
{"food":"strawberries", "totalQuant": 10, "eatenQuant":5},
{"food":"strawberries", "totalQuant": 10, "eatenQuant":6},
{"food":"strawberries", "totalQuant": 10, "eatenQuant":7},
{"food":"strawberries", "totalQuant": 10, "eatenQuant":8},
{"food":"strawberries", "totalQuant": 10, "eatenQuant":9},
{"food":"strawberries", "totalQuant": 10, "eatenQuant":10},
{"food":"strawberries", "totalQuant": 100, "eatenQuant":0},
{"food":"strawberries", "totalQuant": 100, "eatenQuant":1},
{"food":"strawberries", "totalQuant": 100, "eatenQuant":2},
{"food":"strawberries", "totalQuant": 100, "eatenQuant":3},
{"food":"strawberries", "totalQuant": 100, "eatenQuant":4},
{"food":"strawberries", "totalQuant": 100, "eatenQuant":5},
{"food":"strawberries", "totalQuant": 100, "eatenQuant":6},
{"food":"strawberries", "totalQuant": 100, "eatenQuant":7},
{"food":"strawberries", "totalQuant": 100, "eatenQuant":8},
{"food":"strawberries", "totalQuant": 100, "eatenQuant":9},
{"food":"strawberries", "totalQuant": 100, "eatenQuant":10},

{"food":"cookies", "totalQuant": 10, "eatenQuant":0},
{"food":"cookies", "totalQuant": 10, "eatenQuant":1},
{"food":"cookies", "totalQuant": 10, "eatenQuant":2},
{"food":"cookies", "totalQuant": 10, "eatenQuant":3},
{"food":"cookies", "totalQuant": 10, "eatenQuant":4},
{"food":"cookies", "totalQuant": 10, "eatenQuant":5},
{"food":"cookies", "totalQuant": 10, "eatenQuant":6},
{"food":"cookies", "totalQuant": 10, "eatenQuant":7},
{"food":"cookies", "totalQuant": 10, "eatenQuant":8},
{"food":"cookies", "totalQuant": 10, "eatenQuant":9},
{"food":"cookies", "totalQuant": 10, "eatenQuant":10},
{"food":"cookies", "totalQuant": 100, "eatenQuant":0},
{"food":"cookies", "totalQuant": 100, "eatenQuant":1},
{"food":"cookies", "totalQuant": 100, "eatenQuant":2},
{"food":"cookies", "totalQuant": 100, "eatenQuant":3},
{"food":"cookies", "totalQuant": 100, "eatenQuant":4},
{"food":"cookies", "totalQuant": 100, "eatenQuant":5},
{"food":"cookies", "totalQuant": 100, "eatenQuant":6},
{"food":"cookies", "totalQuant": 100, "eatenQuant":7},
{"food":"cookies", "totalQuant": 100, "eatenQuant":8},
{"food":"cookies", "totalQuant": 100, "eatenQuant":9},
{"food":"cookies", "totalQuant": 100, "eatenQuant":10},
{"food":"bananas", "totalQuant": 10, "eatenQuant":0},
{"food":"bananas", "totalQuant": 10, "eatenQuant":1},
{"food":"bananas", "totalQuant": 10, "eatenQuant":2},
{"food":"bananas", "totalQuant": 10, "eatenQuant":3},
{"food":"bananas", "totalQuant": 10, "eatenQuant":4},
{"food":"bananas", "totalQuant": 10, "eatenQuant":5},
{"food":"bananas", "totalQuant": 10, "eatenQuant":6},
{"food":"bananas", "totalQuant": 10, "eatenQuant":7},
{"food":"bananas", "totalQuant": 10, "eatenQuant":8},
{"food":"bananas", "totalQuant": 10, "eatenQuant":9},
{"food":"bananas", "totalQuant": 10, "eatenQuant":10},
{"food":"bananas", "totalQuant": 100, "eatenQuant":0},
{"food":"bananas", "totalQuant": 100, "eatenQuant":1},
{"food":"bananas", "totalQuant": 100, "eatenQuant":2},
{"food":"bananas", "totalQuant": 100, "eatenQuant":3},
{"food":"bananas", "totalQuant": 100, "eatenQuant":4},
{"food":"bananas", "totalQuant": 100, "eatenQuant":5},
{"food":"bananas", "totalQuant": 100, "eatenQuant":6},
{"food":"bananas", "totalQuant": 100, "eatenQuant":7},
{"food":"bananas", "totalQuant": 100, "eatenQuant":8},
{"food":"bananas", "totalQuant": 100, "eatenQuant":9},
{"food":"bananas", "totalQuant": 100, "eatenQuant":10},
{"food":"pies", "totalQuant": 10, "eatenQuant":0},
{"food":"pies", "totalQuant": 10, "eatenQuant":1},
{"food":"pies", "totalQuant": 10, "eatenQuant":2},
{"food":"pies", "totalQuant": 10, "eatenQuant":3},
{"food":"pies", "totalQuant": 10, "eatenQuant":4},
{"food":"pies", "totalQuant": 10, "eatenQuant":5},
{"food":"pies", "totalQuant": 10, "eatenQuant":6},
{"food":"pies", "totalQuant": 10, "eatenQuant":7},
{"food":"pies", "totalQuant": 10, "eatenQuant":8},
{"food":"pies", "totalQuant": 10, "eatenQuant":9},
{"food":"pies", "totalQuant": 10, "eatenQuant":10},
{"food":"pies", "totalQuant": 100, "eatenQuant":0},
{"food":"pies", "totalQuant": 100, "eatenQuant":1},
{"food":"pies", "totalQuant": 100, "eatenQuant":2},
{"food":"pies", "totalQuant": 100, "eatenQuant":3},
{"food":"pies", "totalQuant": 100, "eatenQuant":4},
{"food":"pies", "totalQuant": 100, "eatenQuant":5},
{"food":"pies", "totalQuant": 100, "eatenQuant":6},
{"food":"pies", "totalQuant": 100, "eatenQuant":7},
{"food":"pies", "totalQuant": 100, "eatenQuant":8},
{"food":"pies", "totalQuant": 100, "eatenQuant":9},
{"food":"pies", "totalQuant": 100, "eatenQuant":10},
*/
]
];

var allNames = ["Ann", "Barbara", "Cathy", "Diana", "Emma", "Fiona", "Grace", "Heather", "Iris", "Jane", "Kathy",
"Lena", "Mary", "Nancy", "Olga", "Patty", "Rebecca", "Stephanie", "Tracy", "Victoria", "Wendy", "Yvonne", 
"Albert", "Bob", "Calvin", "David", "Edward", "Frank", "George", "Henry", "Ivan", "Jake", "Kevin", "Larry",
"Matt", "Nathan", "Oliver", "Patrick", "Robert", "Steven", "Tom", "Victor", "Winston", "Zack"];


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

  affects: new Array(numTrials),

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
      var affect = document.affectForm.affect.value;
      
      experiment.affects[currentTrialNum] = affect;
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
      quantifier = trial.quantifier;
      food = foodTypes.random();
      totalQuant = totalQuants.random();

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
      //var utteredSliderIndexName = "#cost" + currentUtteredPriceSliderIndex;
      //$(utteredSliderIndexName).html(numberWithCommas(currentUtteredPrice));
      numComplete++;
    }
  }
}


