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

<@commonPage "${welcomeToSoloLabel}!">
<h2>
    <span>${welcomeToSoloLabel}</span>
    <a target="_blank" href="https://b3log.org">
        <span class="solo">&nbsp;Solo</span>
    </a>
</h2>

<div id="init">
    <div id="authUser">
        <input type="userName" id="userName" />
        <input type="userEmail" id="userEmail" />
        <input type="userPassword" id="userPassword" />
        <button onclick="initLoginAsAdmin();">Login</button>
        <br>
    </div>
</div>
<script type="text/javascript" src="${staticServePath}/js/lib/jquery/jquery.min.js" charset="utf-8"></script>
<script type="text/javascript">
    (function () {
        try {
            $('.wrap').css('padding', ($(window).height() - 450) / 2 + 'px 0')
        } catch (e) {
            document.querySelector('.main').innerHTML = "${staticErrorLabel}<br><br><br><br><br>"
        }
    })()

    var initLoginAsAdmin = function() {
                var requestJSONObject = {
                    "userName": $("#userName").val(),
                    "userEmail": $("#userEmail").val(),
                    "userPassword": $("#userPassword").val()
                };

                $("#tip").html("<img src='${staticServePath}/images/loading.gif'/> loading...")
                $.ajax({
                    url: "${servePath}" + "/initLoginAdmin",
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