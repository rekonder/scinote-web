import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue/dist/vue.esm';
import ShareTaskModalContainer from '../../vue/protocol/modals/share_my_module.vue';
import 'vue2-perfect-scrollbar/dist/vue2-perfect-scrollbar.css';

Vue.use(TurbolinksAdapter);
Vue.prototype.i18n = window.I18n;

function initShareTaskComponent() {
  const container = $('.share-task-modal-container');
  if (container.length) {
    window.ShareTaskModalContainer = new Vue({
      el: '.share-task-modal-container',
      name: 'ShareTaskModalComponent',
      components: {
        'share-task-modal-container': ShareTaskModalContainer
      },
      data() {
        return {
          visibility: true,
          urls: {
            enable: container.data('enable-task-share-url'),
            disable: container.data('disable-task-share-url')
          }
        };
      },
      methods: {
        showModal() {
          this.visibility = true;
        },
        closeModal() {
          this.visibility = false;
        }
      }
    });
  }
}

initShareTaskComponent();
