﻿<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Config.aspx.cs" Inherits="Facility_Config" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
  <title>配置策略</title>
  <style>
    .margin-top {
      margin-top: 5px;
      height: 41px;
    }
  </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  <div class="row">
    <div class="col-md-1"></div>
    <div class="col-md-5">
      <span class="btn btn-block btn-info" id="print1"></span>
      <span class="btn btn-block btn-info" id="print2"></span>
      <span class="btn btn-block btn-info" id="router"></span>
      <span class="btn btn-block btn-info" id="laptop"></span>
      <span class="btn btn-block btn-success" id="msg" style="display:none"></span>
    </div>
    <div class="col-md-5" runat="server">
      <input type="text" class="form-control"  placeholder="打印机获取时间1（格式：11:00）" id="prin1" />
      <input type="text" class="form-control margin-top"  placeholder="打印机获取时间2（格式：11:00）" id="prin2" />
      <input type="text" class="form-control margin-top"  placeholder="路由器时间间隔（格式：5）分钟" id="ruter" />
      <input type="text" class="form-control margin-top"  placeholder="笔记本时间间隔（格式：8）分钟" id="lptop" />
      <a href="#fakelink" class="btn btn-block btn-lg btn-primary margin-top" onclick="check();" id="submit">提交</a>      
    </div>
    <div class="col-md-1"></div>
  </div>

  <script>
    $('#mconfig').addClass('active');
    var cdata = [];

    function getInfo() {
      $.ajax({
        type: "get",
        url: "/Facility/ConfigJSON.aspx?status=get",
        beforeSend: function (XMLHttpRequest) {
          
        },
        success: function (data, textStatus) {
          cdata = eval(data);
          var print1 = cdata[0]["PrintConfig1"];
          var print2 = cdata[0]["PrintConfig2"];
          var router = cdata[0]["RouterConfig"];
          var laptop = cdata[0]["LaptopConfig"];

          $('#print1').text("打印机获取时间设置1: " + print1);
          $('#print2').text("打印机获取时间设置2: " + print2);
          $('#router').text("路由器获取时间间隔: " + router + "分钟");
          $('#laptop').text("笔记本获取时间间隔: " + laptop + "分钟");

          $('#prin1').val(print1);
          $('#prin2').val(print2);
          $('#ruter').val(router);
          $('#lptop').val(laptop);
        },
        complete: function (XMLHttpRequest, textStatus) {
          //HideLoading();
        },
        error: function () {
          //请求出错处理                    
        }
      });
    };    

    function submit() {
      $.ajax({
        type: "get",
        url: "/Facility/ConfigJSON.aspx?status=set"+"&print1="+$('#prin1').val()+"&print2="+$('#prin2').val()+"&router="+$('#ruter').val()+"&laptop="+$("#lptop").val(),
        beforeSend: function (XMLHttpRequest) {
          $('#submit').hide();
          $('#msg').removeClass('btn-danger').addClass('btn-success').text("正在提交").show();
        },
        success: function (data, textStatus) {
          $('#msg').text("更新成功").fadeOut(1500);
          $('#submit').show();
          getInfo();          
        },
        complete: function (XMLHttpRequest, textStatus) {
          //HideLoading();
        },
        error: function () {
          //请求出错处理                    
        }
      });
    }
    
    function check()
    {
      var reg = /^(\d{1,2}):(\d{1,2})$/;
      var print1 = $('#prin1').val();
      var print2 = $('#prin2').val();
      var router = $('#ruter').val();
      var laptop = $('#lptop').val();
      
      if (router == "" || parseInt(router) < 5 || parseInt(router) > 10) {
        $('#msg').removeClass('btn-success').addClass('btn-danger').text("路由器时间间隔5分钟到10分钟且不能为空").show();
      } else if (laptop == "" || parseInt(laptop) < 5 || parseInt(laptop) > 30) {
        $('#msg').removeClass('btn-success').addClass('btn-danger').text("笔记本时间间隔5分钟到30分钟且不能为空").show();
      } else if (!reg.test(print1)) {
        $('#msg').removeClass('btn-success').addClass('btn-danger').text("打印机日期1的格式不正确！").show();
      } else if (!reg.test(print2)) {
        $('#msg').removeClass('btn-success').addClass('btn-danger').text("打印机日期2的格式不正确！").show();
      } else {
        submit();
      }
    }

    getInfo();
  </script>
</asp:Content>

