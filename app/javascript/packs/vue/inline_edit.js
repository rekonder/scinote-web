/* global */

import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue/dist/vue.esm';
import InlineEdit from '../../vue/shared/inline_edit.vue';

Vue.use(TurbolinksAdapter);
Vue.prototype.i18n = window.I18n;

window.initInlineEditComponent = () => {
  const container = $('.inline-editing-container');
  let actionButtonGroup = '.header-actions.experiment-header';

  new Vue({
    el: '.inline-editing-container',
    name: 'InlineEditComponent',
    components: {
      'inline-edit-container': InlineEdit
    },
    data() {
      return {
        value: container.data('value'),
        attributeName: container.data('attribute-name'),
        characterLimit: 255,
        allowBlank: false,
        callbackOnDisabled: true
      };
    },
    methods: {
      updateName(value) {
        var paramsGroup = container.data('params-group');
        var fieldToUpdate = container.data('field-to-update');
        var params = { [paramsGroup]: { [fieldToUpdate]: value } };

        $.ajax({
          url: container.data('path-to-update'),
          type: 'PUT',
          dataType: 'json',
          data: params
        });
      },
      editingEnabled() {
        $('.tooltip').hide();
        $(actionButtonGroup).addClass('hide-actions');
      },
      editingDisabled() {
        $(actionButtonGroup).removeClass('hide-actions');
      }
    }
  });
};

window.initInlineEditComponent();
