pipeline {
    agent any

    environment {
        BIGIP_HOST = '192.168.1.50'
        BIGIP_CREDS = credentials('bigip-admin-credentials')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Static & Logic Conflict Check') {
            steps {
                sh '''
                    python3 -m pip install pyyaml --quiet --break-system-packages
                    python3 scripts/irule_checker.py
                '''
            }
        }

        stage('BIG-IP API Syntax Verification') {
            steps {
                script {
                    // Loop through iRules and validate syntax against real BIG-IP API Sandbox
                    sh '''
                        for rule in irules/*.tcl; do
                            RULENAME=$(basename "$rule" .tcl)
                            RULE_CONTENT=$(jq -sR . "$rule")
                            
                            echo "Validating $RULENAME against BIG-IP..."
                            
                            RESPONSE=$(curl -sk -u "$BIGIP_CREDS_USR:$BIGIP_CREDS_PSW" \
                                -X POST "https://${BIGIP_HOST}/mgmt/tm/ltm/rule" \
                                -H "Content-Type: application/json" \
                                -d "{\"name\": \"temp_${RULENAME}\", \"apiAnonymous\": ${RULE_CONTENT}}" \
                                -w "\n%{http_code}")

                            HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
                            BODY=$(echo "$RESPONSE" | sed '$d')

                            if [ "$HTTP_CODE" -ne 200 ]; then
                                echo "BIG-IP Validation Failed for $RULENAME (HTTP $HTTP_CODE)"
                                echo "$BODY"
                                exit 1
                            else
                                echo "Syntax valid on BIG-IP for $RULENAME"
                                # Clean up temporary rule
                                curl -sk -u "$BIGIP_CREDS_USR:$BIGIP_CREDS_PSW" \
                                    -X DELETE "https://${BIGIP_HOST}/mgmt/tm/ltm/rule/temp_${RULENAME}" > /dev/null
                            fi
                        done
                    '''
                }
            }
        }
    }

    post {
        failure {
            echo "iRule validation failed. Please check the logs above for specific syntax or logic conflicts."
        }
    }
}
