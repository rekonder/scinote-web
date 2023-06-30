<template>
  <div
    ref="modal"
    class="modal fade share-task-modal"
    id="share-task-modal"
    tabindex="-1"
    role="dialog"
    aria-labelledby="shareTaskModalLabel"
  >
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header flex">
          <h4 class="modal-title">
            {{ i18n.t("my_modules.shareable_links.modal.title") }}
          </h4>
          <button
            type="button"
            class="close float-right !ml-auto"
            data-dismiss="modal"
            aria-label="Close"
          >
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <div class="flex items-center text-sm gap-4 mb-4">
            <span>{{ i18n.t("repositories.modal_assign_items_to_task.title") }}</span>
            <span class="sci-toggle-checkbox-container">
              <input type="checkbox" id="checkbox"  class="sci-toggle-checkbox"/>
              <span class="sci-toggle-checkbox-label"></span>
            </span>
          </div>
          <div class="sci-input-container mb-2">
            <textarea ref="textarea"
                      class="sci-input-field !h-36"
                      :placeholder="i18n.t('my_modules.shareable_links.modal.description_placeholder')"
                      @focus="editing = true"
                      @blur="editing = false">
            </textarea>
            <template v-if="editing">
              <div class="sci-btn-group flex float-right">
                <button class="btn btn-secondary" @click="cancel">{{ i18n.t('general.cancel') }}</button>
                <button class="btn btn-secondary" @click="saveDescription">{{ i18n.t('general.save') }}</button>
              </div>
            </template>
          </div>

          <div class="sci-input-container text-sm">
            <div class="mb-2"> {{ i18n.t('my_modules.shareable_links.modal.sharing_link_label') }} </div>
            <div class="flex mb-2">
              <input type="text"
                     class="sci-input-field share-link-input"
                     id="#share-link-input"
                     :disabled="true"
              />
              <button class="btn btn-primary share-link-copy" @click="copy">{{ i18n.t('my_modules.shareable_links.modal.copy_button') }}</button>
            </div>
            <div class="text-xs"> {{ i18n.t('my_modules.shareable_links.modal.disclaimer') }} </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>

export default {
  name: "ShareTaskModalContainer",
  props: {
    visibility: Boolean,
    urls: Object
  },
  data() {
    return {
      editing: false
    };
  },
  mounted() {
    $(this.$refs.modal).on("shown.bs.modal", () => {
    });

    $(this.$refs.modal).on("hidden.bs.modal", () => {
    });
  },
  created() {
    window.ShareTaskModalContainer = this;
    this.$nextTick(() => {
      this.showModal();
    });
  },
  watch: {
    visibility() {
      if (this.visibility) {
        this.showModal();
      } else {
        this.hideModal();
      }
    }
  },
  methods:{
    showModal() {
      $(this.$refs.modal).modal("show");
    },
    hideModal() {
      $(this.$refs.modal).modal("hide");
    },
    copy() {

    },
    saveDescription() {

    },
    cancel() {

    }
  }
};
</script>
