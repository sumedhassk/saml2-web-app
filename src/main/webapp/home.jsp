<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html>
<!--
~   Copyright (c) 2020 WSO2 Inc. (http://wso2.com) All Rights Reserved.
~
~   Licensed under the Apache License, Version 2.0 (the "License");
~   you may not use this file except in compliance with the License.
~   You may obtain a copy of the License at
~
~        http://www.apache.org/licenses/LICENSE-2.0
~
~   Unless required by applicable law or agreed to in writing, software
~   distributed under the License is distributed on an "AS IS" BASIS,
~   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
~   See the License for the specific language governing permissions and
~   limitations under the License.
-->
<%@ page import="org.wso2.carbon.identity.sso.agent.bean.LoggedInSessionBean" %>
<%@ page import="org.wso2.carbon.identity.sso.agent.util.SSOAgentConstants" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.wso2.cloud.sample.webapp.CommonUtil"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="org.wso2.cloud.sample.webapp.ClaimManagerProxy" %>

<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="PICKUP DISPATCH - Vehicle allocation application">


    <title>WSO2 Cloud</title>
    <link rel="icon" type="image/png" href="img/favicon.png"/>

    <!-- Bootstrap Material Design CSS -->
    <link href="libs/bootstrap-material-design_4.0.0/css/bootstrap-material-design.min.css" rel="stylesheet">
    <!-- Font Awesome icons -->
    <link href="libs/fontawesome-5.2.0/css/fontawesome.min.css" rel="stylesheet">
    <link href="libs/fontawesome-5.2.0/css/solid.min.css" rel="stylesheet">
    <!-- Golden Layout styles -->
    <link href="libs/goldenlayout/css/goldenlayout-base.css" rel="stylesheet">
    <!-- Highlight styles -->
    <link href="libs/highlight_9.12.0/styles/atelier-cave-light.css" rel="stylesheet">

    <!-- Custom styles -->
    <link href="css/spinner.css" rel="stylesheet">
    <link href="css/custom.css" rel="stylesheet">
    <link href="css/dispatch.css" rel="stylesheet">
</head>
    <%
        String subjectId = null;
        final String SAML_SSO_URL = "samlsso";
        final String SAML_LOGOUT_URL = "logout";
        String samlResponse = "";

        ServletContext context = pageContext.getServletContext();
        boolean isSAMLGrantEnabled = Boolean.parseBoolean(context.getInitParameter("saml-sso-grant-enabled"));

        // if web-browser session is there but no session bean set,
        // invalidate session and direct back to login page
        JSONObject requestObject = new JSONObject();
        requestObject.append("requestEndpoint", request.getRequestURI());
        if (request.getSession(false) != null
                && request.getSession(false).getAttribute(SSOAgentConstants.SESSION_BEAN_NAME) == null) {
            request.getSession().invalidate();
    %>
            <script type="text/javascript">
                location.href = "index.jsp";
            </script>
    <%
            return;
        }

        LoggedInSessionBean sessionBean = (LoggedInSessionBean) session.getAttribute(SSOAgentConstants.SESSION_BEAN_NAME);

        final Map<String, String> subjectAttributeValueMap = sessionBean.getSAML2SSO().getSubjectAttributes();

        ClaimManagerProxy claimManagerProxy = (ClaimManagerProxy) application.getAttribute("claimManagerProxyInstance");

        final Map<String, String> subjectAttributeDisplayValueMap =
                        claimManagerProxy.getLocalClaimUriDisplayValueMapping(new ArrayList<>(subjectAttributeValueMap.keySet()));

        if (sessionBean != null && sessionBean.getSAML2SSO() != null) {
            subjectId = sessionBean.getSAML2SSO().getSubjectId().toLowerCase();
            samlResponse =  CommonUtil.marshall(sessionBean.getSAML2SSO().getSAMLResponse());
            samlResponse = StringEscapeUtils.escapeXml(samlResponse);
        } else {
    %>
            <script type="text/javascript">
                location.href = <%=SAML_SSO_URL%>;
            </script>
    <%
            return;
        }
    %>

<body class="app-home dispatch">

<div id="wrapper" class="wrapper"></div>

<div id="actionContainer">
    <nav class="navbar navbar-expand-lg navbar-dark app-navbar justify-content-between">
        <a class="navbar-brand" href="home.jsp"><i class="fas fa-cloud"></i> WSO2 Cloud</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavDropdown"
                aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNavDropdown">
            <ul class="navbar-nav flex-row ml-md-auto ">
                <li class="nav-item dropdown ">
                    <a class="nav-link dropdown-toggle user-dropdown" href="#" id="navbarDropdownMenuLink"
                       data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <i class="fas fa-user-circle"></i> <span><%=subjectId%></span>
                    </a>
                    <div class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
                        <a class="dropdown-item" href="#" id="profile"><i class="fas fa-address-card"></i>
                            <span>&nbsp;&nbsp;&nbsp;Profile</span>
                        </a>
                        <a class="dropdown-item" href=<%=SAML_LOGOUT_URL%>><i class="fas fa-sign-out-alt"></i>
                            <span>&nbsp;&nbsp;&nbsp;Logout</span>
                        </a>
                    </div>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="toggleView" href="#" data-toggle="tooltip" data-placement="bottom" title="Console">
                        <i class="fa fa-cogs"></i>
                    </a>
                </li>
            </ul>
        </div>
    </nav>

    <main role="main" class="main-content">
        <div id="main-content">
            <section class="jumbotron text-center">
                <div class="container">
                    <div class="jumbotron-heading">WSO2 Cloud</div>
                    <p class="lead text-muted">SAML Sample</p>
                </div>
            </section>
            <div class="container">
                <section id="tabs">
                    <div class="row">
                        <div class="col-md-12">
                            <nav>
                                <div class="col-md-6 d-block mx-auto">
                                    <div class="nav nav-tabs nav-fill" id="nav-tab" role="tablist">
                                        <a class="nav-item nav-link active" id="nav-overview-tab" data-toggle="tab"
                                           href="#nav-overview" role="tab" aria-controls="nav-overview" aria-selected="true"><i
                                                class="fas fa-address-card"></i> &nbsp;Logged in User Details</a>
                                        <% if (isSAMLGrantEnabled) { %>
                                        <a class="nav-item nav-link" id="nav-saml-grant-tab" data-toggle="tab" href="#nav-drivers"
                                           role="tab" aria-controls="nav-drivers" aria-selected="false"><i
                                                class="fas fa-key"></i> &nbsp;Try SAML Grant</a>
                                        <% } %>
                                    </div>
                                </div>
                            </nav>
                            <div class="tab-content py-3 px-3 px-sm-0" id="nav-tabContent">
                                <div class="tab-pane fade show active" id="nav-overview" role="tabpanel"
                                     aria-labelledby="nav-overview-tab">
                                    <div class="table-responsive content-table">
                                        <% if (!subjectAttributeValueMap.isEmpty()) { %>
                                        <table class="table">
                                            <thead>
                                            <tr>
                                                <th>Claim URL</th>
                                                <th>Claim Value</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <% for (String attribute:subjectAttributeValueMap.keySet()) { %>
                                            <tr>
                                                <% if (subjectAttributeDisplayValueMap.containsKey(attribute)) { %>
                                                <td><%=subjectAttributeDisplayValueMap.get(attribute)%> </td>
                                                <% } else { %>
                                                <td><%=attribute%> </td>
                                                <% } %>
                                                <td><%=subjectAttributeValueMap.get(attribute).toString() %> </td>
                                            </tr>
                                            <% } %>
                                            </tbody>
                                        </table>
                                        <%  } else {%>
                                        <p align="center">No user details Available. Configure SP Claim Configurations.</p>
                                        <%  } %>
                                    </div>
                                </div>
                                <% if (isSAMLGrantEnabled) { %>
                                <div class="tab-pane fade" id="nav-drivers" role="tabpanel" aria-labelledby="nav-drivers-tab">
                                    <form action="token">
                                        <input type="submit" id="btn-generate" class="btn btn-generate btn-login"
                                               value="Generate Token"/>
                                    </form>
                                </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </section>
            </div>
        </div>
        <div id="profile-content">
            <section class="jumbotron text-center">
                <div class="container">
                    <div class="user-icon">
                        <i class="fas fa-user-circle fa-5x"></i>
                    </div>
                    <div class="jumbotron-heading"><%=subjectId%></div>
                </div>
            </section>
            <div class="container">
                <div class="row">
                    <div class="col-md-6 d-block mx-auto">
                        <div class="card card-body table-container">
                            <div class="table-responsive content-table">
                                <% if (!subjectAttributeValueMap.isEmpty()) { %>
                                    <table class="table">
                                        <thead>
                                        <tr>
                                            <th rowspan="2">User Details</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                            <% for (String attribute:subjectAttributeValueMap.keySet()) { %>
                                                <tr>
                                                    <% if (subjectAttributeDisplayValueMap.containsKey(attribute)) { %>
                                                        <td><%=subjectAttributeDisplayValueMap.get(attribute)%> </td>
                                                    <% } else { %>
                                                        <td><%=attribute%> </td>
                                                    <% } %>
                                                    <td><%=subjectAttributeValueMap.get(attribute).toString() %> </td>
                                                </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                <%  } else {%>
                                        <p align="center">No user details Available. Configure SP Claim Configurations.</p>
                                <%  } %>
                            </div>
                        </div>
                        <!--</div>-->
                    </div>
                </div>
                </section>
            </div>
        </div>
    </main><!-- /.container -->
    <footer class="text-muted footer text-center">
        <span>Copyright  &copy;  <a href="http://wso2.com/cloud" target="_blank">
            <img src="img/wso2-dark.svg" class="wso2-logo" alt="wso2-logo"> </a> Cloud | <span class="year">
            <%= Calendar.getInstance().get(Calendar.YEAR)%></span>
        </span>
    </footer>

    <!-- sample application actions message -->
    <div class="modal fade" id="sampleModal" tabindex="-1" role="dialog" aria-labelledby="basicModal" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="myModalLabel">You cannot perform this action</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                </div>
                <div class="modal-body">
                    <p>Sample application functionalities are added for display purposes only.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-dismiss="modal">OK</button>
                </div>
            </div>
        </div>
    </div>
</div>
<div id="viewContainer">
    <section class="actions">
        <div class="container-fluid">
            <div class="row">
                <div class="col-md-12 console-headers">
                    <span id="console-close" class="float-right console-action">
                        <span data-toggle="tooltip" data-placement="bottom" title="Close"><i
                                class="fas fa-times"></i></span>
                    </span>
                    <span id="toggleLayout" class="float-right console-action">
                        <span data-toggle="tooltip" data-placement="bottom" title="Dock to bottom"><i
                                class="fas fa-window-maximize"></i></span>
                    </span>
                    <span id="clearAll" class="float-right console-action">
                        <span data-toggle="tooltip" data-placement="bottom" title="Clear All"><i class="fas fa-ban"></i></span>
                    </span>

                </div>
                <div class="col-md-12">
                    <div id="timeline-content">
                        <ul class="timeline">
                            <li class="event sent">
                                <div class="request-response-infos">
                                    <h1 class='request-response-title'>Request <span class="float-right"><i
                                            class="fas fa-angle-down"></i></span></h1>
                                    <div class="request-response-details mt-3">
                                        <h2>Data:</h2>
                                        <div class="code-container mb-3">
                                            <button class="btn btn-primary btn-clipboard"
                                                    data-clipboard-target=".copy-target1"><i
                                                    class="fa fa-clipboard"></i></button>
                                            <p class="copied">Copied..!</p>
                                            <pre><code class="copy-target1 JSON pt-3 pb-3"><%=requestObject.toString(4)%></code></pre>
                                        </div>
                                    </div>
                                </div>
                                <input type="hidden" id="request" value="<%=requestObject.toString()%>"/>
                            </li>
                            <li class="event received">
                                <div class="request-response-infos">
                                    <h1 class='request-response-title'>Response <span class="float-right"><i
                                            class="fa fa-angle-down"></i></span></h1>
                                    <div class="request-response-details mt-3">
                                        <h2>Data:</h2>
                                        <div class="code-container mb-3">
                                            <button class="btn btn-primary btn-clipboard"
                                                    data-clipboard-target=".copy-target3"><i
                                                    class="fa fa-clipboard"></i></button>
                                            <p class="copied">Copied..!</p>
                                            <pre><code class="copy-target3 JSON pt-3 pb-3 requestContent"><%=samlResponse%></code></pre>
                                        </div>
                                    </div>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>

<!-- JQuery -->
<script src="libs/jquery_3.3.1/jquery.min.js"></script>
<!-- Popper -->
<script src="libs/popper_1.12.9/popper.min.js"></script>
<!-- Bootstrap Material Design JavaScript -->
<script src="libs/bootstrap-material-design_4.0.0/js/bootstrap-material-design.min.js"></script>
<!-- Moment -->
<script src="libs/moment_2.11.2/moment.min.js"></script>
<!-- Golden Layout -->
<script src="libs/goldenlayout/js/goldenlayout.min.js"></script>
<!-- Highlight -->
<script src="libs/highlight_9.12.0/highlight.pack.js"></script>
<!-- Clipboard -->
<script src="libs/clipboard/clipboard.min.js"></script>
<!-- Custom Js -->
<script src="js/custom.js"></script>
<script>hljs.initHighlightingOnLoad();</script>

</body>
</html>
