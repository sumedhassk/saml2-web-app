/*
 * Copyright (c) 2020, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package org.wso2.cloud.sample.webapp;

import org.wso2.carbon.identity.sso.agent.bean.SSOAgentConfig;
import org.wso2.carbon.identity.sso.agent.oauth2.SAML2GrantManager;
import org.wso2.carbon.identity.sso.agent.util.SSOAgentConstants;
import org.wso2.carbon.identity.sso.agent.util.SSOAgentFilterUtils;
import org.wso2.carbon.identity.sso.agent.util.SSOAgentRequestResolver;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Filter for SAML Grant
 */
public class SAMLGrantFilter implements Filter {

    private static final Logger LOGGER = Logger.getLogger(SSOAgentConstants.LOGGER_NAME);

    protected FilterConfig filterConfig = null;

    /**
     * @see Filter#init(FilterConfig)
     */
    @Override
    public void init(FilterConfig fConfig) {
        this.filterConfig = fConfig;
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain)
            throws IOException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        SAML2GrantManager saml2GrantManager;
        String redirectPath = filterConfig.getServletContext().getContextPath() + "/oauth.jsp";
        try {
            SSOAgentConfig ssoAgentConfig = SSOAgentFilterUtils.getSSOAgentConfig(filterConfig);
            SSOAgentRequestResolver resolver =
                    new SSOAgentRequestResolver(request, response, ssoAgentConfig);
            if (resolver.isSAML2OAuth2GrantRequest()) {
                saml2GrantManager = new SAML2GrantManager(ssoAgentConfig);
                saml2GrantManager.getAccessToken(request, response);
            } else {
                String errorMsg = "Error while generating the Access Tokens. Check the OAuth2 SAML2 Grant " +
                        "configurations";
                redirectPath = redirectPath + "?error=true&" + "msg=" + errorMsg;
            }
            response.sendRedirect(redirectPath);
        } catch (Exception e) {
            LOGGER.log(Level.FINE, "Error!", e);
            String errorMsg = "Error while generating the Access Tokens. " + e.getMessage()
                    + ". Reason: " + e.getCause().getMessage();
            redirectPath = redirectPath + "?error=true&" + "msg=" + errorMsg;
            response.sendRedirect(redirectPath);
        }
    }

    @Override
    public void destroy() {
    }
}
