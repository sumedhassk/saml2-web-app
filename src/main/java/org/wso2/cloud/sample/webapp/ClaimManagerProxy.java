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

import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * This is a utility that helps to map OIDC and SAML claims to their display values.
 * It utilize WSO2 Identity Server's claim management APIs.
 *
 * Usage of claim mapping is not MANDATORY for OIDC and SAML usage. But it helps to display claim values in an
 * appropriate manner.
 */
public class ClaimManagerProxy {

    private final List<Node> localClaimNodes;

    public ClaimManagerProxy() {
        localClaimNodes = new ArrayList<>();
    }

    public Map<String, String> getLocalClaimUriDisplayValueMapping(List<String> localClaimUriList) {

        Map<String, String> claimDisplayValueMap = new HashMap<>();

        // Iterate and filter for required local claim URIs
        for (Node node : this.localClaimNodes) {
            Element nsElement = (Element) node;

            // Find prefix  ex:- ax2342
            String prefix = nsElement.getAttribute("xsi:type").split(":")[0];

            NodeList localClaimUriElement = nsElement.getElementsByTagName(prefix + ":localClaimURI");

            String claimUri = localClaimUriElement.item(0).getTextContent();

            //  Check for local claim URI matching
            if (localClaimUriElement.getLength() == 1 && localClaimUriList.contains(claimUri)) {

                String displayValue =
                        getDisplayValueFromNodeList(nsElement.getElementsByTagName(prefix + ":claimProperties"));

                if (displayValue != null) {
                    claimDisplayValueMap.put(claimUri, displayValue);
                } else {
                    // Put claim uri as it is
                    claimDisplayValueMap.put(claimUri, claimUri);
                }
            }
        }

        return claimDisplayValueMap;
    }

    // Dedicated method to extract display value from list of claim property nodes
    private static String getDisplayValueFromNodeList(NodeList claimPropertyNodes) {

        for (int j = 0; j < claimPropertyNodes.getLength(); j++) {
            // Extract property value when property name text is "DisplayName"
            NodeList propertyChildren = claimPropertyNodes.item(j).getChildNodes();

            for (int k = 0; k < propertyChildren.getLength(); k++) {
                if ("DisplayName".equals(propertyChildren.item(k).getTextContent())) {
                    // Extract propertyValue
                    if (k == 0) {
                        return propertyChildren.item(1).getTextContent();
                    } else {
                        return propertyChildren.item(0).getTextContent();
                    }
                }
            }
        }
        return null;
    }

}
