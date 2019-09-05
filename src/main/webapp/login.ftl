<#--

    Solo - A small and beautiful blogging system written in Java.
    Copyright (c) 2010-2019, b3log.org & hacpai.com

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.

-->
<#include "macro-common-page.ftl">

<@commonPage "${loginLabel}">
<h2>
${loginLabel}
</h2>
<div id="authUser">
    <input type="userName" id="userName" />
    <input type="userPassword" id="userPassword" />
    <button onclick="loginWithNormal();">Login</button>
    <br>
</div>
<script type="text/javascript" src="${staticServePath}/js/lib/jquery/jquery.min.js" charset="utf-8"></script>
<script type="text/javascript">
    $('.wrap').css('padding', ($(window).height() - 450) / 2 + 'px 0')

    var loginWithNormal = function() {
            var requestJSONObject = {
                "userName": $("#userName").val(),
                "userPassword": $("#userPassword").val()
            };

            $("#tip").html("<img src='${staticServePath}/images/loading.gif'/> loading...")
            $.ajax({
                url: "${servePath}" + "/normalLogin",
                type: "POST",
                cache: false,
                data: requestJSONObject,
                success: function(result, textStatus) {
                    $("#tip").text(result.msg);
                    if (!result.sc) {
                        return;
                    }
                    setTimeout(function() {
                        window.location.href = "${servePath}";
                    }, 1000);
                }
            })
        }
</script>
</@commonPage>