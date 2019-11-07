/*
 * Solo - A small and beautiful blogging system written in Java.
 * Copyright (c) 2010-2019, b3log.org & hacpai.com
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
package org.b3log.solo.processor;

import com.google.gson.JsonObject;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang.RandomStringUtils;
import org.apache.commons.lang.StringUtils;
import org.b3log.latke.Keys;
import org.b3log.latke.Latkes;
import org.b3log.latke.ioc.Inject;
import org.b3log.latke.logging.Level;
import org.b3log.latke.logging.Logger;
import org.b3log.latke.model.User;
import org.b3log.latke.service.LangPropsService;
import org.b3log.latke.servlet.HttpMethod;
import org.b3log.latke.servlet.RequestContext;
import org.b3log.latke.servlet.annotation.RequestProcessing;
import org.b3log.latke.servlet.annotation.RequestProcessor;
import org.b3log.latke.servlet.renderer.AbstractFreeMarkerRenderer;
import org.b3log.latke.util.Requests;
import org.b3log.solo.model.Common;
import org.b3log.solo.model.Option;
import org.b3log.solo.model.UserExt;
import org.b3log.solo.service.*;
import org.b3log.solo.util.Skins;
import org.b3log.solo.util.Solos;
import org.json.JSONArray;
import org.json.JSONObject;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * Login/logout processor.
 *
 * @author <a href="http://88250.b3log.org">Liang Ding</a>
 * @author <a href="http://vanessa.b3log.org">Liyuan Li</a>
 * @author <a href="mailto:dongxu.wang@acm.org">Dongxu Wang</a>
 * @author <a href="https://github.com/nanolikeyou">nanolikeyou</a>
 * @version 1.1.1.19, Jan 25, 2019
 * @since 0.3.1
 */
@RequestProcessor
public class LoginProcessor {

    /**
     * Logger.
     */
    private static final Logger LOGGER = Logger.getLogger(LoginProcessor.class);

    /**
     * Language service.
     */
    @Inject
    private LangPropsService langPropsService;

    /**
     * DataModelService.
     */
    @Inject
    private DataModelService dataModelService;

    /**
     * Preference query service.
     */
    @Inject
    private PreferenceQueryService preferenceQueryService;

    /**
     * Options query service.
     */
    @Inject
    private OptionQueryService optionQueryService;

    /**
     * User query service.
     */
    @Inject
    private UserQueryService userQueryService;

    /**
     * Initialization service.
     */
    @Inject
    private InitService initService;

    /**
     * Shows login page.
     *
     * @param context the specified context
     */
    @RequestProcessing(value = "/login", method = HttpMethod.GET)
    public void showLogin(final RequestContext context) {
        String destinationURL = context.param(Common.GOTO);
        if (StringUtils.isBlank(destinationURL)) {
            destinationURL = Latkes.getServePath() + Common.ADMIN_INDEX_URI;
        } else if (!isInternalLinks(destinationURL)) {
            destinationURL = Latkes.getServePath();
        }

        if (null != Solos.getCurrentUser(context.getRequest(), context.getResponse())) {
            context.sendRedirect(destinationURL);

            return;
        }

        final AbstractFreeMarkerRenderer renderer = new SkinRenderer(context, "login.ftl");
        final Map<String, Object> dataModel = renderer.getDataModel();
        final JSONObject preference = optionQueryService.getOptions(Option.CATEGORY_C_PREFERENCE);
        try {
            Skins.fillLangs(preference.optString(Option.ID_C_LOCALE_STRING), (String) context.attr(Keys.TEMAPLTE_DIR_NAME), dataModel);
            dataModelService.fillCommon(context, dataModel, preference);
        } catch (final Exception e) {
            LOGGER.log(Level.ERROR, e.getMessage(), e);

            context.sendError(HttpServletResponse.SC_NOT_FOUND);
        }

        Solos.addGoogleNoIndex(context);
    }

    /**
     * login with username & password
     *
     * @param context
     */
    @RequestProcessing(value = "/normalLogin", method = HttpMethod.POST)
    public void login(final RequestContext context) {
        final HttpServletRequest request = context.getRequest();
        final HttpServletResponse response = context.getResponse();
        final String userName = context.param("userName");
        final String userPassword = context.param("userPassword");

        JSONObject user = userQueryService.getUserByEmailOrUserName(userName);
        if (null == user) {
            return ;
        }

        String password = DigestUtils.md5Hex(userPassword);

        if (!user.optString("userPassword").equals( DigestUtils.md5Hex(userPassword))) {
            return ;
        }

        Solos.login(user, response);
        context.sendRedirect(Latkes.getServePath());
        LOGGER.log(Level.INFO, "Logged in [email={0}, remoteAddr={1}] with GitHub oauth", userName, Requests.getRemoteAddr(request));

        return;
    }

    /**
     * the first time when initing whole blog to set admin user
     *
     * @param context
     */
    @RequestProcessing(value = "/initLoginAdmin", method = HttpMethod.POST)
    public void initAdmin(final RequestContext context) {
        final HttpServletRequest request = context.getRequest();
        final HttpServletResponse response = context.getResponse();

        final String userName = context.param("userName");
        final String userEmail = context.param("userEmail");
        final String userPassword = context.param("userPassword");
        final String userAvatar = context.param("userAvatar");

        if (!initService.isInited()) {
            final JSONObject initReq = new JSONObject();
            initReq.put(User.USER_NAME, userName);
            initReq.put(User.USER_EMAIL, userEmail);
            initReq.put(User.USER_PASSWORD, userPassword);
            initReq.put(UserExt.USER_AVATAR, userAvatar);

            try {
                initService.init(initReq);
            } catch (final Exception e) {
                // ignored
            }

            JSONObject user = userQueryService.getUserByEmailOrUserName(userName);
            if (null == user) {
                user = userQueryService.getUserByEmailOrUserName(userEmail);
            }

            Solos.login(user, response);
            context.sendRedirect(Latkes.getServePath());
            LOGGER.log(Level.INFO, "Logged in [email={0}, remoteAddr={1}] with GitHub oauth", userEmail, Requests.getRemoteAddr(request));

            return;
        } else {
            login(context);
        }
    }

    /**
     * Logout.
     *
     * @param context the specified context
     */
    @RequestProcessing(value = "/logout", method = HttpMethod.GET)
    public void logout(final RequestContext context) {
        final HttpServletRequest httpServletRequest = context.getRequest();

        Solos.logout(httpServletRequest, context.getResponse());

        String destinationURL = context.param(Common.GOTO);
        if (StringUtils.isBlank(destinationURL) || !isInternalLinks(destinationURL)) {
            destinationURL = Latkes.getServePath();
        }

        context.sendRedirect(destinationURL);
        Solos.addGoogleNoIndex(context);
    }

    /**
     * Preventing unvalidated redirects and forwards. See more at:
     * <a href="https://www.owasp.org/index.php/Unvalidated_Redirects_and_Forwards_Cheat_Sheet">https://www.owasp.org/index.php/
     * Unvalidated_Redirects_and_Forwards_Cheat_Sheet</a>.
     *
     * @return whether the destinationURL is an internal link
     */
    private boolean isInternalLinks(String destinationURL) {
        return destinationURL.startsWith(Latkes.getServePath());
    }
}
