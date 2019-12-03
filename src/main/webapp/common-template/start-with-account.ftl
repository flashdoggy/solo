<#--

    Solo - A small and beautiful blogging system written in Java.
    Copyright (c) 2010-present, b3log.org

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
<#include "macro-common_page.ftl">

<@commonPage "${welcomeToSoloLabel}!">
<h2 class="start-page-h2">
    <span>${welcomeToSoloLabel}</span>
    <a target="_blank" href="https://taoism-one.com/">
        <span class="error">&nbsp;${myBlogLabel}</span>
    </a>
</h2>

<div id="github">
    <div id="account">
        <form id="login">
            <input type="text" id="username" />
            <input type="password" id="password" /><br />
            <button type="button" id="login" >${login}</button>
        </form>
    </div>
</div>
<script type="text/javascript" src="${staticServePath}/js/lib/jquery/jquery.min.js" charset="utf-8"></script>
<script type="text/javascript">
    $(document).ready(function(){
        $('button#login').on('click', function () {
            var queryJsonObject = {
                'username': $('#username').val(),
                'password': $('#password').val()
            };

            $.ajax({
                url: '${servePath}/login',
                type: 'POST',
                data: queryJsonObject,
                cache: false,
                success: function (result, textStatus) {
                    if (result.userName == queryJsonObject.username) {
                        window.location.href = '${servePath}';
                    }
                    $("#tip").text(result.msg);
                }});
        });

        /* css style for start page only */
        $('.content-wrap').attr("style", "background-image:url(${startBackgroundImage});");
        $('.start-page-h2').css("background-color","#FFFFFF");
        $('input').css({"width":"50%"});
        $('button#login').css("width", "30%");
    });
</script>
</@commonPage>
