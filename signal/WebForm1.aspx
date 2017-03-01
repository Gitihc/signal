<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="signal.WebForm1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="Scripts/jquery-1.6.4.min.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery.signalR-1.1.4.min.js" type="text/javascript"></script>
    <script src='<%: ResolveClientUrl("~/signalr/hubs") %>'></script>
    <script type="text/javascript">
        $(function () {

            //前端Hub的使用，注意的是，Hub的名字是WorkflowHub，这里使用时首字母小写
            var work = $.connection.signalser;
            
            $('#displayname').val(prompt('请输入昵称:', ''));
            $('#thisname').text('当前用户：' + $('#displayname').val());

            //对应后端的SendMessage函数，消息接收函数
            work.client.sendMessage = function (message) {
                $('#messgae').append(message + '</br>')
            };

            //后端SendLogin调用后，产生的loginUser回调
            work.client.loginUser = function (userlist) {
                reloadUser(userlist);
            };

            //hub连接开启
            $.connection.hub.start().done(function () {

                var username = $('#displayname').val();

                //发送上线信息
                work.server.sendLogin(username);

                //点击按钮，发送消息
                $('#send').click(function () {
                    var friend = $('#username').val();
                    //调用后端函数，发送指定消息
                    work.server.sendByGroup(username, friend);
                });

            });
        });

        //重新加载用户列表
        var reloadUser = function (userlist) {
            $("#username").empty();
            for (i = 0; i < userlist.length; i++) {
                $("#username").append("<option value=" + userlist[i] + ">" + userlist[i] + "</option>");
            }
        }
    </script>
</head>
<body>
    <h1>
        流程演示</h1>
    <input type="hidden" id="displayname" />
    <h2 id="thisname">
    </h2>
    <br />
    <select id="username" style="width: 153px;">
    </select>
    <input id="send" type="button" value="发送" />
    <div>
        <h1 id="messgae">
        </h1>
    </div>
</body>
</html>
