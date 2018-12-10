////////////////////////////////////////////////
//// Setting up a general ajax method to handle
//// transfer of data between client and server
////////////////////////////////////////////////
var crime_investigations;

function run_ajax(method, data, link, callback=function(res){crime_investigation.get_crime_investigations()}){
  $.ajax({
    method: method,
    data: data,
    url: link,
    success: function(res) {
      crime_investigation.errors = {};
      callback(res);
    },
    error: function(res) {
      console.log("error");
      crime_investigation.errors = res.responseJSON;
    }
  })
}

//////////////////////////////////////////////
//// A component to create a dosage list item
//////////////////////////////////////////////
 Vue.component('crime-investigation-row', {
      // Start with the template: two methods to consider...
      // (1) defining where to look for the HTML template in the index view
      template: '#crime-investigation-row',
      // _or_ (2) define it directly in the js file as such:
      // template:`
      //   <li>
      //     {{ investigation_note.date }}&nbsp;&nbsp;
      //     {{ investigation_note.officer_id }}:&nbsp;&nbsp;
      //     {{ investigation_note.content }}
      //   </li>
      // `,
      // Passed elements to the component from the Vue instance
      props: {
        crime_investigation: Object
      },
    
      // Behaviors associated with this component
      methods: {
        remove_record: function(crime_investigation){
          run_ajax('DELETE', {crime_investigation: crime_investigation}, '/crime_investigations/'.concat(crime_investigation['id'], '.json'));       
        }
      }
    });
    
/////////////////////////////////////////
//// A component for adding a new note
/////////////////////////////////////////
var new_form = Vue.component('new-crime-investigation-form', {
  template: '#crime-investigation-form',

  mounted() {
    // need to reconnect the materialize select javascript 
    $('#crime_investigation_crime_id').material_select()
  },

  data: function () {
    return {
        investigation_id: 0,
        crime_id: 0,
        errors: {}
    }
  },

  methods: {
    submitForm: function (x) {
      new_post = {
        investigation_id: this.investigation_id,
        crime_id: this.crime_id
      }
      run_ajax('POST', {crime_investigation: new_post}, '/crime_investigations.json')
      this.switch_modal()
    }
  },
})


//////////////////////////////////////////
////***  The Vue instance itself  ***////
/////////////////////////////////////////
var crime_investigation = new Vue({

  el: '#crime_investigation_handling',

  data: {
    investigation_id: 0,
    crime_investigations: [],
    modal_open: false,
    errors: {}
  },

  created() {
    // read the investigation_id from the page when instance created
    this.investigation_id = $('#investigation_id').val();
  },

  methods: {
    switch_modal: function(event){
      this.modal_open = !(this.modal_open);
    },

    get_crime_investigations: function(){
      run_ajax('GET', {}, '/investigations/'.concat(this.investigation_id, '/crime_investigations.json'), function(res){crime_investigation.crime_investigations = res});
    },
  },

  mounted: function(){
    this.get_crime_investigations();
  }
});

