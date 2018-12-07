////////////////////////////////////////////////
//// Setting up a general ajax method to handle
//// transfer of data between client and server
////////////////////////////////////////////////
// var investigation_notes;

function run_ajax(method, data, link, callback=function(res){investigation_notes.get_investigation_notes()}){
  $.ajax({
    method: method,
    data: data,
    url: link,
    success: function(res) {
      investigation_notes.errors = {};
      callback(res);
    },
    error: function(res) {
      console.log("error");
      investigation_notes.errors = res.responseJSON;
    }
  })
}

//////////////////////////////////////////////
//// A component to create a dosage list item
//////////////////////////////////////////////
 Vue.component('investigation-note-row', {
      // Start with the template: two methods to consider...
      // (1) defining where to look for the HTML template in the index view
      // template: '#investigation-note-row',
      // _or_ (2) define it directly in the js file as such:
      template:`
        <li>
          {{ investigation_note.date }}:&nbsp;&nbsp;
          {{ investigation_note.officer }}:&nbsp;&nbsp;
          {{ investigation_note.content }}:&nbsp:&nbsp;
        </li>
      `,
      // Passed elements to the component from the Vue instance
      props: {
        investigation_note: Object
      },
    
      // Behaviors associated with this component
      methods: {
        // remove_record: function(dosage){
        //   run_ajax('DELETE', {dosage: dosage}, '/dosages/'.concat(dosage['id'], '.json'));       
        // }
      }
    });
    
/////////////////////////////////////////
//// A component for adding a new note
/////////////////////////////////////////
var new_form = Vue.component('new-investigation-note-form', {
  template: '#investigation-note-form',

  mounted() {
    // need to reconnect the materialize select javascript 
    // $('#note_investigation_id').material_select()
  },

  data: function () {
    return {
        investigation_id: 0,
        officer_id: 0,
        content: '', 
        date: '',
        errors: {}
    }
  },

  methods: {
    submitForm: function (x) {
      new_post = {
        investigation_id: this.investigation_id,
        officer_id: this.officer_id,
        content: this.content,
        date: this.date
      }
      run_ajax('POST', {investigation_note: new_post}, '/investigation_notes.json')
      this.switch_modal()
    }
  },
})

//////////////////////////////////////////
////***  The Vue instance itself  ***////
/////////////////////////////////////////
var investigation_note = new Vue({

  el: '#investigation_note_handling',

  data: {
    investigation_id: 0,
    // officer_id: 0,
    investigation_notes: [],
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

    get_investigation_notes: function(){
      run_ajax('GET', {}, '/investigations/'.concat(this.investigation_id, '/investigation_notes.json'), function(res){investigation_notes.investigation_notes = res});
    }
  },

  mounted: function(){
    this.get_investigation_notes();
  }
});

