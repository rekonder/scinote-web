/* global notTurbolinksPreview */

(function() {
  'use strict';

  function initializeHandsonTable(el) {
    var input = el.siblings('input.hot-table-contents');
    var inputObj = JSON.parse(input.attr('value'));
    var metadataJson = el.siblings('input.hot-table-metadata');
    var data = inputObj.data;
    var metadata;

    metadata = JSON.parse(metadataJson.val() || '{}');
    el.handsontable({
      disableVisualSelection: true,
      rowHeaders: true,
      colHeaders: true,
      editor: false,
      copyPaste: false,
      formulas: true,
      data: data,
      cell: metadata.cells || []
    });
  }

  function initAttachments() {
    $(document).on('click', '.shareable-file-preview-link, .shareable-gallery-switcher', function(e) {
      e.preventDefault();
      $('.modal-file-preview.in').modal('hide');
      $($(`.modal-file-preview[data-object-id=${$(this).data('id')}]`)).modal('show');
    });
  }

  function initResultsExpandCollapse() {
    $(document).on('click', '#results-collapse-btn', function() {
      $('.result .panel-collapse').collapse('hide');
    });

    $(document).on('click', '#results-expand-btn', function() {
      $('.result .panel-collapse').collapse('show');
    });
  }

  function initMyModuleResultsShow() {
    initAttachments();
    initResultsExpandCollapse();

    $('.hot-table-container').each(function() {
      initializeHandsonTable($(this));
    });
  }

  if (notTurbolinksPreview()) {
    initMyModuleResultsShow();
  }
}());
