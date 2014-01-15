﻿<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="StoreInformation.aspx.cs" Inherits="Store_StoreInformation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
  <title>门店信息维护</title>
  <style type="text/css">
    .ui-jqgrid .ui-pg-input { height:20px;font-size:.8em; margin: 0;}    
  </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  <div class="row">        
    <div class="col-md-12 div-center">
      <div>                
        <table id="tbStores"></table>  
        <div id="pager"></div>                               
      </div>                      
    </div>        
  </div>

  <script type="text/javascript">
    $('#mstores').addClass('active');

    var lastsel;
    var alertbar = $('#alertbar');

    function captionCenter(gridName) {
      $(gridName).closest("div.ui-jqgrid-view")
                .children("div.ui-jqgrid-titlebar")
                .css("text-align", "center")
                .children("span.ui-jqgrid-title")
                .css("float", "none");
    };

    function storeNo() {
      var sel_id = $('#tbStores').jqGrid('getGridParam', 'selrow');
      var value = $('#tbStores').jqGrid('getCell', sel_id, 'StoreNo');
      return value;
    }

    function sync() {
      $.ajax({
        type: "get",
        url: "/Store/StoreJSON.aspx?status=sync",
        beforeSend: function (XMLHttpRequest) {
          alertbar.text("正在同步...");
          alertbar.fadeIn(1000);
        },
        success: function (data, textStatus) {
          alertbar.text(data);
          alertbar.fadeOut(1000);
          $('#tbStores').trigger('reloadGrid');
        },
        complete: function (XMLHttpRequest, textStatus) {
          //HideLoading();
        },
        error: function () {
          //请求出错处理                    
        }
      });
    };

    $('#tbStores').jqGrid({
      url: '/Store/StoreJSON.aspx?status=all',
      datatype: "json",
      colNames: ["店号", "区域", "类型", "打印机IP", "路由器IP", "笔记本IP1", "笔记本IP2", "邮件地址", "打印机型号", "墨盒型号", "路由器型号"],
      colModel: [
          { name: "StoreNo", index: "StoreNo", width: 50, align: "center", editoptions: { readonly: "readonly" }, editable: true },
          { name: "StoreRegion", index: "StoreRegion", width: 50, align: "center", editable: false },
          { name: "StoreType", index: "StoreType", width: 50, align: "center", editable: false },
          { name: "PrinterIP", index: "PrinterIP", width: 120, align: "center", editable: true },
          { name: "RouterIP", index: "RouterIP", width: 120, align: "center", editable: true },
          { name: "LaptopIP1", index: "LaptopIP1", width: 120, align: "center", editable: true },
          { name: "LaptopIP2", index: "LaptopIP2", width: 120, align: "center", editable: true },
          { name: "EmailAddress", index: "EmailAddress", width: 250, align: "center", editable: true },
          { name: "PrinterType", index: "PrinterType", width: 100, align: "center", editable: true },
          { name: "TonerType", index: "TonerType", width: 100, align: "center", editable: true },
          { name: "RouterType", index: "RouterType", width: 100, align: "center", editable: true },
      ],
      rowNum: 500,
      sortname: 'StoreNo',
      viewrecords: true,
      sortorder: "desc",
      caption: "店铺信息维护",
      height: 500,
      scrollrows: true,
      gridComplete: function () {
        captionCenter('#tbStores');
      },            
      toppager: true,
      editurl: "/Store/StoreJSON.aspx",
    });
    
    $('#tbStores').jqGrid('navGrid', "#pager", { edit: true, add: false, del: true, search: false, refresh: false, cloneToTop: true },
                          {
                            closeAfterEdit: true
                          }, // edit parameters
                          {

                          }, // add parameters
                          {
                            delData: {
                              name: storeNo
                            }
                          },
                          {},
                          {});    
   
    $("#tbStores").navButtonAdd('#tbStores_toppager', {
      caption: "",
      title: "同步店铺信息",
      buttonicon: "ui-icon-transferthick-e-w",
      onClickButton: sync,
      position: "first"
    });
    
  </script>
</asp:Content>
