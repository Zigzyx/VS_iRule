when HTTP_REQUEST {
    if { [HTTP::has_responded] } { return };
    set host_header [string tolower [HTTP::host]]
    set uri_info [string tolower [HTTP::uri]]
    set remote [IP::remote_addr]
    set method [HTTP::method]
    persist none

    if { [HTTP::path] equals "/api/v2/purchases/validations/recurrents" } {
      HTTP::uri "/api/v2/purchases/validations/recurrents/enquiry"
    }

    switch -glob $uri_info {
        "/kimonotm*" {
          if { ($proto equals "http") } {
            HTTP::redirect https://[getfield [HTTP::host] ":" 1][HTTP::uri]
            return
          }

          persist none
          pool kimonotms_pool
          return
        }

        "/api/v1/chat" {
          #pool isw-customer-support-bot_default_k8_prod
        }

        "/project-x*" {
          pool project_x_consumer_pool
        }

        "/paymentgateway/api/v1/transactions/qr/do-transaction" {
	       if { ([class match $remote equals corporate_proxy]) or ([class match $remote equals kenya_public ]) } {
	         pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
	         return
	       }

	       reject
	       return
          }

        "/paymentgateway/api/v1/billpayments/banks/lookup/FBN" {
	       if { ([class match $remote equals FBN_IP]) } {
	         pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
	         return
	       }

	       reject
	       return
          }

          "/robots.txt" {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          }


        "/paymentgateway/api/v1/billpayments/banks/notification/FBN" {
	       if { ([class match $remote equals FBN_IP]) } {
	         pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
	         return
	       }

	       reject
	       return
          }


        "paymentgateway/api/v1/virtualaccounts/wema/callback" {
	       if { ([class match $remote equals WEMA_IP]) } {
	         pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
	         return
	       }

	       reject
	       return
          }

        "/paymentgateway/api/v1/settlements/split-settlement-summary*" {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
        }

        "/paymentgateway/qtb/v1/settlements/split-settlement-summary*" {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        }
        
        "/paymentgateway/api/v1/settlements/pos/deductions*" {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
        }

        "/paymentgateway/qtb/v1/settlements/pos/deductions*" {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        }

       "/paymentgateway/qtb*" {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        }

       "/paymentgateway*" {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
       }

       "/pos-transaction-reporting/*" {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
       }


       "/storefront*" {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
       }
        
       "/collections/api/v1/payments*" {
       if {$method eq "GET"}
        {
           pool pool_isw_collections_prod
         }
       }
        
        "/collection*" {
          pool pool_isw_payment_gateway_prod
        }

       "/api/v1/fees/cal*" {
        #   pool api-gateway_default_k8_prod
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
       }

       "/api/v1/apigateway/status" {
        #   pool api-gateway_default_k8_prod
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
       }

       "/api/v1/creditcard/*" {
          pool pool_credit_card_portal
       }

      "/api/v1/purchase*" {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
       }

       "/api/v3/purchases/otps/resend" {
           pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
       }

       "/api/v3/purchases/otps/auths" {
       if {$method eq "POST"}
        {
           pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
         }
       }

       "/api/v2/purchases/validations/recurrents/enquiry" {
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        return
      }

        "/api/v1/ext/*" {
           pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
           return
       }

      "/api/v2/purchases/recurrents" {
        if {$method eq "POST"}
        {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
        }
        # pool payment-service-get_default_k8_prod
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        return
      }
      "/api/v2/purchases/recurrents/tokenize" {
        if {$method eq "POST"}
        {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
        }
        # pool payment-service-get_default_k8_prod
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        return
      }
      "/api/v2/purchases/recurrents/tokenize/otps" {
        if {$method eq "POST"}
        {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
        }
        # pool payment-service-get_default_k8_prod
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        return
      }


     "/api/v3/purchases" {
        if {$method eq "POST"}
        {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
        }
        # pool payment-service-get_default_k8_prod
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress

      }

      "/api/v3/purchase*" {
       if {$method eq "POST"}
        {
              pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress

         }
       }


     "/api/v2/purchases/otps/auths" {
       if {$method eq "POST"}
        {
           pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
         }
       }

     "/api/v2/purchases" {
        if {$method eq "POST"}
        {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return

        }
        # pool payment-service-get_default_k8_prod
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
       }


      "/api/v2/purchase*" {
       if {$method eq "POST"}
        {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
         }
       }


       "/api/v2/quickteller*" {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
       }

        "/api/v1/lookup/custome*" {
          pool isw_customer_lookup_service
        }

        "/api/scorebridge*" {
          pool scorebridge_verve_api_service
        }

        "/cardless-servic*" {
           if { [HTTP::header host] eq "172.16.11.200" || [HTTP::header host] eq "api.interswitchng.com"}{
            HTTP::header replace Host "cardless-service-prod.k2.isw.la"
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
           }
            # pool cardless_api_pool
        }


        "/smartinsur*" {
          pool smartinsure_api
        }

        "/safeto*" {
          pool safetoken_api_v2_pool
        }

        "/arbite*" {
          pool pool_arbiter_prod
        }

        "/passpor*" {
           if { [HTTP::header host] eq "172.16.11.200" || [HTTP::header host] eq "172.22.10.11" }
           {
                HTTP::header replace Host "passport-v2-prod.k2.isw.la"
                pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
                return
            #  pool passport-v2_default_k8_prod
            #  return  
           }
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        }

        "/api/v1/pwm*" {
        #   if { $host_header contains "172"}
            # {
            # HTTP::header replace Host "cardlessservice-prod.k2.isw.la"
            # }
            # pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            # pool esb_cardlessservice_path_lb_k8_prod
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          if {$remote eq "172.25.2.233"}{
            log local0. "FBN paywith Mobile $uri_info"
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
          }
        }

        "/autopay_ap*" {
           pool autopay-api-service
        }

        "/fingerprint*" {
           pool fingerprint_api_pool
        }

        "/social-servic*" {
          pool quickteller_social_service_pool
        }

        "/scorebridge*" {
          #pool scorebridge_rest
         # pool scorebridge-input-module-rest_default_k8_prod
        }

        "/incognit*" {
        #   pool incognito_default_k8_prod
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        }

        "/lending-servic*" {
          if { [HTTP::header host] eq "172.16.11.200" }{
              HTTP::header replace Host "lending-service-prod.ingress.isw.la"
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
          }
          #pool lending-service_default_k8_prod
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        }

        "/api/healths" {
          pool 	/cis/Shared/nginx_ingress_controller_80_nginx_ingress
        }

        "/api/billpaymentservice" {
          pool 	/cis/Shared/nginx_ingress_controller_80_nginx_ingress
        }

        "/es/*" {
           persist cookie
           pool kimonoes_pool
           return
        }
        
        "/kmw/v2/kimonoservice/ipaas" {
           pool kimonomiddleware_ipaas
           return
        }

        "/kmw/keydownloadservice" {
            pool kimonomiddleware_pool_parts
            return
        }

        "/kmw/v2/kimonoservice/internal" {
           node 172.35.9.5 7075
           return
        }


        "/kmw*" {
           pool kimonomiddleware_pool
           return
        }

        "/rbp*" {
            if { [HTTP::header host] eq "172.16.11.200" }{
                HTTP::header replace Host "recurrent-billing-prod.k2.isw.la"
                pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
                return
             }
        #   pool recurrent-billing_default_k8_prod
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
           return
        }

        "/transfer-service*" {
           #pool isw-transfer-service_default_k8_prod
           return
        }

        "/retail-ecosystem*" {
           pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
           return
        }

        "/api/v1/strong/auth/user*" {
          HTTP::header replace Host "strongauthservice-prod.k2.isw.la"
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        #   pool esb_strongauthservice_path_lb_k8_prod
       }

    }

    if { ($host_header equals "myververworld.com") } {
        HTTP::redirect "https://www.interswitchgroup.com/card-network"
        return
      }

    if { ($host_header equals "interswitch.interswitchng.com") } {
        HTTP::redirect "https://interswitchng.crm4.dynamics.com"
        return
    }
            
    if { ($host_header equals "hipchat.interswitchng.com") } {
      #node 172.25.15.74 443
      HTTP::header insert "X-Forwarded-Proto" "https";
      pool pool_hipchat
      #HTTP::redirect "https://172.25.15.74[HTTP::uri]"
      return
    }

    if { ($host_header equals "totalbulkcardfunding.interswitchgroup.com") } {
        switch -glob $uri_info {

            "/card-fundin*" {
            #  pool total-bulk-card-funding_default_k8_prod
            }

            "/*" {
            #   pool total-bulk-card-funding-frontend_default_k8_prod
            }
        }
    }

      if { ($host_header equals "smartcardprocess.interswitchgroup.com") } {

         switch -glob $uri_info {
          "/*" {
             node 172.25.15.75 80
          }
         }
        #node 172.25.15.75 80
      }

    #   if { ($host_header equals "tsa.interswitchgroup.com") } {
    #     pool firs-ui_default_k8_prod
    #   }
    #  if { ($host_header equals "bifrostmfb.interswitchgroup.com") or ($host_header equals "app.providusbank.com") } {
    #     pool bifrostmfb-apigateway-pool_prod
    #   }


    #   if { ($host_header equals "lcc-integration.interswitchgroup.com") } {
    #     pool lcc-mis-integration_default_k8_prod
    #   }

      if { ($host_header equals "developer.interswitchgroup.com") } {
        if {($uri_info starts_with "/docs") }{
            #pool iswdocs_default_k8_prod
            HTTP::redirect "https://docs.interswitchgroup.com/"
            return
        }
        # Makeshift fix for docs assests loading from base
		switch -glob [HTTP::header "Referer"] {
		   "https://developer.interswitchgroup.com/docs*" {
		       if {($uri_info != "/") }{
		       #    pool iswdocs_default_k8_prod
		           return
		       }
		    }
		}

        #pool developer-interswitchng_default_k8_prod
        #pool prod_ingress_node_pool
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
     } 


      if { ($host_header equals "nag.interswitchng.com") } {
        HTTP::header insert "X-Forwarded-Proto" "https";
              switch -glo $uri_info {

        "/nagios-prod/cgi-bin/pagerduty*" {
          HTTP::uri "/nagios/cgi-bin/pagerduty.cgi"
          node 172.25.30.36 80
        }

        "/nagios-dr/cgi-bin/pagerduty*" {
          HTTP::uri "/nagios/cgi-bin/pagerduty.cgi"
          node 172.46.1.85 80
        }
      }
      }

      if { ($host_header equals "tlstest.interswitchng.com") || ($host_header equals "tlsdebug.interswitchng.com")  } {
        set ssl_version [string tolower [SSL::cipher version]]

        set status 400
        if { ($ssl_version equals "tlsv1.2") } {
          set status 200
        }

        if { $status equals 200 } {
           HTTP::respond 200 content "Interswitch Connection Test Success: $ssl_version"
           return
        } else {
           HTTP::respond 400 content "Interswitch Connection Test Failure: $ssl_version"
           return
        }

        return
      }

    #   if { ($host_header equals "mufasa.interswitchng.com") } {
    #     pool mufasa_static_pool
    #     return
    #   }

      if { ($host_header equals "cvmrewards.interswitchgroup.com") } {
        
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
        }
      
      if { ($host_header equals "alumni.interswitchgroup.com") } {
        
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
      }

      if { ($host_header equals "pilotnew.interswitchgroup.com") } {
      
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        return
      }
      

      if { ($host_header equals "transport.interswitchgroup.com") } {
        switch -glob $uri_info {
        "/admin*" {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
        }

        "/operator*" {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
        }
        "/*" {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
        }
      }
    }

      if { ($host_header equals "spectranet.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
      }

      if { ($host_header equals "isw-multipay-portal.interswitchng.com") } {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
      }

      if { ($host_header equals "isw-collections-multipay.interswitchng.com") } {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
      }

      if { ($host_header equals "energymarketplace.interswitchgroup.com") } {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
      }
      if { ($host_header equals "vendor-energymarketplace.interswitchgroup.com") } {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
      }
      if { ($host_header equals "admin-energymarketplace.interswitchgroup.com") } {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
      }
      if { ($host_header equals "energy-identity.interswitchgroup.com") } {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
      }
      if { ($host_header equals "corporate360.interswitchgroup.com") } {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
      }
      if { ($host_header equals "mobility-pmp.interswitchgroup.com") } {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
      }

      if { ($host_header equals "api-mobility-pmp.interswitchgroup.com") } {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
      }

      if { ($host_header equals "homes-api.interswitchgroup.com") } {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
      }

      if { ($host_header equals "kogistate.interswitchng.com") } {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
      }

      if { ($host_header equals "tvpcore-api.interswitchng.com") } {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
      }

      if { ($host_header equals "tvptoken-api.interswitchng.com") } {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
      }

      if { ($host_header equals "passport-rebirth.interswitchng.com") } {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
      }

      if { ($host_header equals "startup.interswitchgroup.com") } {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
      }
      if { ($host_header equals "product-mesh.com") } {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
      }
      if { ($host_header equals "www.product-mesh.com") } {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
      }
      if { ($host_header equals "www.tappit.product-mesh.com") } {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
      }
      if { ($host_header equals "tappit.product-mesh.com") } {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
      }
      if { ($host_header equals "pbox-listener.interswitchgroup.com") } {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
      }
      if { ($host_header equals "verve-tap-backend-api.interswitchgroup.com") } {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
      }
      if { ($host_header equals "ocms-backend-api.interswitchgroup.com") } {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
      }
      if { ($host_header equals "quickteller-tap-backend-api.interswitchgroup.com") } {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
      }
      if { ($host_header equals "smeter-backend-api.interswitchgroup.com") } {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
      }
      if { ($host_header equals "vendhub.redpay.africa") } {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
      }
      

    if { ($host_header equals "wibmo.interswitchng.com") } {
        if { [HTTP::uri] starts_with "/securecode" } {
            set uri [string map -nocase {"/securecode" "/securecode/cardinal"} [HTTP::uri]]
            HTTP::uri $uri
            pool pool_esb_securecode
            #node 172.35.15.24 8080
        }
    }


    if { ($host_header equals "smartcard-client.interswitchng.com") } {
            #pool smart-card-client_default_k8_prod
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return 
      }
      

    #  if { ($host_header equals "fci-portal.interswitchng.com") } {
    #         pool prod_ingress_node_pool
    #         return
    #   }

     if { ($host_header equals "fintech-self-service.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
      }

     if { ($host_header equals "isw-payment-gateway-multipay.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
      }
     if { ($host_header equals "pxm-multipay.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
      }
      
      if { ($host_header equals "cardfusion.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
      }

     if { ($host_header equals "mps-multipay.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
      }

    if { ($host_header equals "automated-tests-service.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
      }

      if { ($host_header equals "isw-core.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
      }

      if { ($host_header equals "infrabot.interswitchng.com") } {
            pool spinnaker-cluster
            return
      }

     if { ($host_header equals "cards360-api.interswitch.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
      }

    #  if { ($host_header equals "bills.interswitchng.com") } {
    #         node 172.25.15.75 80
    #         # pool uat_billspayment
    #         # pool prod_ingress_node_pool
    #         return
    #         # switch -glob $uri_info {
    #         #     "/v4/billpaymentservice*" { 
    #         #        node 172.26.40.115 8082
    #         #     }
    #         # }
    #     }

    if { ($host_header equals "isw-limit-service.interswitchng.com") } {
            pool isw-limit-service
            return
      }

    if { ($host_header equals "fintech-self-service.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
      }
      
    if { ($host_header equals "logs.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
      }
    
    if { ($host_header equals "acquirerportal.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
      }
      
    if { ($host_header equals "payouts.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
      }

    if { ($host_header equals "homes-api.interswitchng.com") || ($host_header equals "fci-portal.interswitchng.com") || ($host_header equals "automated-tests-service.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
    }

    if { ($host_header equals "fintech-card-management.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
    }

    if { ($host_header equals "ils-hosted-fields.interswitchng.com") } {
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        return
    }


      if { ($host_header equals "transport-api.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
      }

      if { ($host_header equals "transaction-api.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
      }

      if { ($host_header equals "qtt-transaction-api.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
      }

    if { ($host_header equals "api-playground.interswitchng.com")} {	   
		switch -glob $uri_info {

			"/*" {
				pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
           }
		}
  }

    if { ($host_header equals "postcard-api.interswitchng.com") } {
            #pool postcard-api-v2_default_k8_prod
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
      } 


      if { ($host_header equals "pilot.spectranet.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
      }
      
      if { ($host_header equals "pilot-kimono.interswitchng.com") } {
            pool kimonomiddleware_pilot
            return
      }

       if { ($host_header equals "paas-monitoring-portal.interswitchgroup.com")} {	   
		switch -glob $uri_info {

			"/*" {
				# pool prod_ingress_node_pool
				pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
           }

           "/api/v1/*" {
				# pool prod_ingress_node_pool
				pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
			}

		}

  } 


      if { ($host_header equals "paas-monitoring-portal.interswitchng.com")} {	   
		switch -glob $uri_info {

			"/*" {
				#pool prod_ingress_node_pool
				pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
           }

           "/api/v1/*" {
				#pool prod_ingress_node_pool
				pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
			}

		}

  } 
    
    if { $host_header equals "portal.interswitchgroup.com"  &&  $uri_info starts_with "/spa/ops-central" }
    {
      HTTP::respond 301 Location "https://portal.interswitchgroup.com/spa/oneview"
      return
    }
    

      if { ($host_header equals "onboarding.interswitchgroup.com")} {	   
		pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
		return
	    } 

      if { ($host_header equals "contractmanagement.smartfuel.interswitchng.com") } {

         pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        return
      }
      if { ($host_header equals "infrabots.interswitchng.com") } {
         pool spinnaker-cluster
        return
      }
      if { ($host_header equals "customer.smartfuel.interswitchng.com") } {
        #pool uber4diesel-frontend-customer-ag_default_k8_prod
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        return
      }

      if { ($host_header equals "fleet.smartfuel.interswitchng.com") } {
        #pool uber4diesel-frontend-fleet-ag_default_k8_prod
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        return
      }
      if { ($host_header equals "vendor.smartfuel.interswitchng.com") } {
        #pool uber4diesel-frontend-vendor-ag_default_k8_prod
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        return
      }


     if { ($host_header equals "smartfuel.interswitchng.com") } {
      switch -glob $uri_info {

        "/forecourt*" {
           #pool forecourt-middleware-service_default_k8_prod
           pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
           return
         }

        "/smartfuel-userms*" {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
        }

        "/smartcard-cms*" {
          #pool smartcard-cms_default_k8_prod
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
        }

        "/smartfuel-reportms*" {
          #pool smartfuel-reportms_default_k8_prod
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
        }

        "/smartfuel-trx*" {
          #pool smartfuel-trx_default_k8_prod
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
        }
        "/kobo360-trx*" {
          #pool smartfuel-trx_default_k8_prod
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
        }

        "/smartfuel-cms*" {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
        }
        "/kobo360-cms*" {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
        }
        "/customer*" {
           #pool uber4diesel-frontend-customer-ag_default_k8_prod
           pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
           return
	   }
	   "/fleet*" {
            #pool uber4diesel-frontend-fleet-ag_default_k8_prod
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
        }
       "/vendor*" {
         #pool uber4diesel-frontend-vendor-ag_default_k8_prod
         pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
         return
       }
       "/isw*" {
           #pool uber4diesel-frontend-isw-ag_default_k8_prod
           pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
           return
	    }
		"/contractmanagement*" {
           #pool smartfuel-frontend-ag_default_k8_prod
           pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
           return
		}
		"/u4dn*" {
           #pool uber-for-diesel-ag-notification-service_default_k8_prod
           pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
           return
		}
	    "/u4do*" {
           #pool uber-for-diesel-ag-ordermgmt-service_default_k8_prod
           pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
           return
		}
	    "/u4da*" {
           #pool uber-for-diesel-ag-auth-
           pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
           return
		}

		"/uber4diesel*" {
           #pool uber4diesel-report-service_default_k8_prod
           pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
           return
		}

		 "/itg*" {
         pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
       }
		"/*" {
          #pool uber4diesel-frontend-isw-ag_default_k8_prod
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
        }
      }
    }

     if { ($host_header equals "escrow.interswitchng.com") } {
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        # pool escrow-service_default_k8_prod
      }

     if { ($host_header equals "escrowfulfillment.interswitchng.com") } {
      #pool escrow-fulfillment-ui_default_k8_prod
      pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
    }

    if { ($host_header equals "quicktellerfuel.interswitchgroup.com") } {
         switch -glob $uri_info {
            "/customer*" {
               #pool uber4diesel-frontend-customer_default_k8_prod
               pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
                return
			   }
			  "/fleet*" {
               #pool uber4diesel-frontend-fleet_default_k8_prod
               pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
                return
      	       }
	           "/vendor*" {
                 #pool uber4diesel-frontend-vendor_default_k8_prod
                 pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
                 return
		       }
             "/isw*" {
               #pool uber4diesel-frontend-isw_default_k8_prod
               pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
               return
			}
		    "/u4dn*" {
               # pool uber-for-diesel-notification-service_default_k8_prod
               pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
               return
			}
		    "/u4do*" {
               #pool uber-for-diesel-ordermgmt-service_default_k8_prod
               pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
               return
			}
		    "/u4da*" {
               #pool uber-for-diesel-auth-service_default_k8_prod
               pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
               return
			}
	    	"/smartfuel-userms*" {
              pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
              return
            }
            "/smartcard-cms*" {
              #pool smartcard-cms_default_k8_prod
              pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
              return
            }
            "/smartfuel-reportms*" {
              pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
              return
            }
            "/smartfuel-trx*" {
              pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
              return
            }
            "/smartfuel-cms*" {
              pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
              return
            }
    		"/rfid-report*" {
    		 # pool rfid-report-service_default_k8_prod
    		  return
    		}
    	   "/rfid-middleware*" {
    		# pool rfid-middleware-service_default_k8_prod
    		 return
    		}
    		"/rfid-gen*" {
    		 # pool rfid-gen-service_default_k8_prod
    		  return
    		}
    	   "/corporate-rfid*" {
    		 # pool rfid-corporate-service_default_k8_prod
    		  return
    		}
    		"/ovh-integratio*" {
               pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
               return
		    }
    		"/smartfuel-vs*" {
    		   pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
    		   return
    		}
        }
    }

    #  if { ($host_header equals "selfmade.interswitchgroup.com") } {
    #    pool pool_credit_card_portal
    #  }
     if { ($host_header equals "api-iswenergy.interswitchgroup.com") } {
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        # pool escrow-service_default_k8_prod
      }

    if { ($host_header equals "selfmade.interswitchgroup.com") } {
         switch -glob $uri_info {
            "/fidelity/*" {
			   HTTP::uri "[substr [HTTP::uri] 9]"
               pool pool_credit_card_portal
               return
			}

            "/" {
			   HTTP::redirect "https://$host_header/fidelity/"
               return
			}

            "/fidelity*" {
			   HTTP::uri "/[substr [HTTP::uri] 9]"
               pool pool_credit_card_portal
               return
			}

            "/*" {               
               pool pool_credit_card_portal
               return
			}
         }
    }

      if { ($host_header equals "inclusion.interswitchgroup.com") } {

        switch -glo $uri_info {

          "/" {
            HTTP::redirect https://inclusion.interswitchgroup.com/MerchantApp/rest/login
            return
          }


          "/adminapp*" {
            if { ([class match $remote equals corporate_proxy]) } {
              pool gmpp_prod_admin_app
              return
            }

            reject
            return
          }
        }
      }


      #Migrated from 172.25.20.214

          if { ($host_header equals "kimono.interswitchng.com") } {


    switch -glob $uri_info {
       "/kimonotm*" {
          node 172.25.15.54 8091
       }

       "/kimon*" {

          if { !(($remote starts_with "172.25.15.") or ($remote starts_with "172.16.11.")) } {
            if { ($proto equals "http") } {
              HTTP::redirect https://[getfield [HTTP::host] ":" 1][HTTP::uri]
              return
            }
          }

          pool pool_kimono
          return
       }

       "/es*" {

          if { !(($remote starts_with "172.25.15.") or ($remote starts_with "172.16.11.")) } {
            if { ($proto equals "http") } {
              HTTP::redirect https://[getfield [HTTP::host] ":" 1][HTTP::uri]
              return
            }
          }

          pool kimonoes_pool
          return
       }

       "/kmw/v2/kimonoservice/ipaas" {
          if { !(($remote starts_with "172.25.15.") or ($remote starts_with "172.16.11.")) } {
            if { ($proto equals "http") } {
              HTTP::redirect https://[getfield [HTTP::host] ":" 1][HTTP::uri]
              return
            }
          }
          pool kimonomiddleware_ipaas
          return
       }
       
       "/kmw/v2/kimonoservice/internal" {
          if { !(($remote starts_with "172.25.15.") or ($remote starts_with "172.16.11.")) } {
            if { ($proto equals "http") } {
              HTTP::redirect https://[getfield [HTTP::host] ":" 1][HTTP::uri]
              return
            }
          }
          node 172.35.9.5 7075
          return
       }


       "/kmw*" {

          if { !(($remote starts_with "172.25.15.") or ($remote starts_with "172.16.11.")) } {
            if { ($proto equals "http") } {
              HTTP::redirect https://[getfield [HTTP::host] ":" 1][HTTP::uri]
              return
            }
          }

          pool kimonomiddleware_pool
          return
       }
      }
    }

      if { ($host_header equals "kimono-tms-rest.interswitchng.com") } {
        node 172.35.9.17 7074
      }

      if { ($host_header equals "smart.interswitchng.com") } {
        pool pool_smart_services
      }

      if { ($host_header equals "customer.234diesel.interswitchng.com") } {
        #pool uber4diesel-frontend-customer_default_k8_prod
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        }


      if { ($host_header equals "isw-apigateway.interswitchgroup.com") } {
        pool api-gateway-mangement-pool
      }

    if { ($host_header equals "projectsurvey.interswitchgroup.com") } {
        node 172.16.10.101 42733
      }
      
    if { ($host_header equals "paymatebills.interswitchng.com") } {
      node 172.25.0.28 8186
    }    

      if { ($host_header equals "strongauth.interswitchng.com") } {
        pool  esb_strongauthservice_path_lb_k8_prod
      }

      if { ($host_header equals "cardlessadmin.interswitchng.com") } {
        pool pool_cardless_service_admin_ui
      }

      if { ($host_header equals "newwebpay.interswitchng.com") || ($host_header equals "pay.zivastores.com") } {
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        # pool prod_ingress_node_pool
        #pool webpay-ui_default_k8_prod
      }
     if { ($host_header equals "business.sidianbank.co.ke") } {
        if { not ([HTTP::uri] ends_with "?acquiredBy=SID" || [HTTP::query] contains "acquiredBy=SID") } {
            HTTP::redirect "https://[getfield $host_header ":" 1][HTTP::uri]?acquiredBy=SID"
            return
        } else {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        }
        return  
      }

    if {  ($host_header equals "storefront.sidianbank.co.ke") } {
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress

      }
    if {  ($host_header equals "webpay.sidianbank.co.ke") } {
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress

      }

      if { ($host_header equals "retailportal.interswitchng.com") } {
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        #pool webpay-ui_default_k8_prod
      }
      if { ($host_header equals "quickteller-kyc.interswitchng.com" ) } {
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        return
      }

      if { ($host_header equals "ifissupport.com") || ($host_header equals "www.ifissupport.com") } {
        #reject
        if { !($host_header starts_with "www.") }{
          HTTP::redirect https://www.ifissupport.com[HTTP::uri]
          return
        }
        #pool ifis_service_prod_pool
       # pool ifis-service_default_k8_prod
      }

      if { ($host_header equals "passport.interswitchng.com") } {
        # persist cookie

        switch -glob $uri_info {

          "/passport/api/v1/accounts/recovery*" {
              # HTTP::respond 403 content "Access Denied" "Content-Type" "text/plain"
              # return
              reject
            }

          "/passport/p/*" {
            HTTP::uri [string map -nocase {"passport/p/" "p/"} [HTTP::uri]]
            pool mufasa_static_pool
            return
          }
          "/paymentgateway*" {
            # pool project-x-merchant_default_k8_prod
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          }

          "/*" {
             #pool passport-v2_default_k8_prod
                pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          }
        }
      }

    if { ($host_header equals "spectranet.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
    }

    if { ($host_header equals "x-api.interswitchng.com") } {
      switch -glob $uri_info {

        "/api/v1/verve*" {
          pool pool_esb_quickteller
        }

        "/api/v1/scorebridge*" {
          pool pool_esb_default
        }

        "/api/v1/fees/cal*" {
        #   pool paydirect-service_default_k8_prod
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        }

        "/*" {
          pool project_x_consumer_pool
        }
      }
    }


      if { ($host_header equals "v2-portal.interswitchng.com") } {
        #   pool isw-portal-v2_default_k8_prod
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
      }

      if { ($host_header equals "ax.interswitchgroup.com") } {
          node 172.16.10.101 8090
          return
      }
      if { ($host_header equals "iot.interswitch.com") } {
          node 172.35.14.91 8080
          return
      }

      if { ($host_header equals "portal.interswitchgroup.com") } {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          # pool isw-portal-v2_default_k8_prod
          return
      }
     
      if { ($host_header equals "survey.interswitchng.com") } {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
      }
      if { ($host_header equals "paypoint-middleware-api.interswitchgroup.com") } {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
      }
      if { ($host_header equals "qtmove-backend-api.interswitchgroup.com") } {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
      }

      if { ($host_header equals "next.interswitchgroup.com") } {
          pool new_interswitch_website
          return
      }

      if { ($host_header equals "quickdata.interswitchgroup.com") } {
        persist cookie
        pool quickdata-interswitchgroup
        #node 172.16.10.74 83
        return
      }
      
      if { ($host_header equals "einvoicing-app.interswitchng.com") } {
          node 172.35.14.25 8080
          return
      }

       if { ($host_header equals "einvoicing-api.interswitchng.com") } {
          node 172.35.14.25 8080
          #node 172.35.14.25 8085
          return
      }
      
        if { ($host_header equals "api-einvoicing.interswitchng.com") } {
          node 172.35.14.25 8085
          #pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
      }
       if { ($host_header equals "einvoice16.firs.gov.ng") } {
          node 172.35.14.25 8080
          return
      }

      if { ($host_header equals "portal.interswitchng.com") } {

          #if { ($remote equals "172.16.10.20") } {
          #pool 	isw-portal_default_k8_prod
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
          #}
      }

      if { ($host_header equals "ship-access-gateway.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
      }

      if { ($host_header equals "ship-billing.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
      }

      if { ($host_header equals "help.interswitchng.com") } {
        persist cookie
        pool help-interswitchgroup
        #HTTP::redirect https://help.interswitchgroup.com[HTTP::uri]
      }

      if { ($host_header equals "help.interswitchgroup.com") } {
        persist cookie
        pool help-interswitchgroup

        # node 172.16.10.74 83
      }

      if { ($host_header equals "crmclient.interswitchgroup.com") } {
        persist cookie
        pool crmclient

      }

      if { ($host_header equals "insights.interswitchng.com") } {
        persist cookie
        pool insights-eam
      }

     if { ($host_header equals "virtualcard.interswitchng.com" ) } {
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        return
      }
      

     if { ($host_header equals "qmms.interswitchng.com" ) } {
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        return
      }

     if { ($host_header equals "agency-banking-terminal-registration-portal.interswitchng.com" ) } {
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        return
      }

     if { ($host_header equals "wmu.interswitchng.com" ) } {
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        return
      }

     if { ($host_header equals "qmmu.interswitchng.com" ) } {
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        return
      }

      if { ($host_header equals "channels-rewards.interswitch.com" ) } {
        #pool prod_ingress_node_pool
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        return
      }
       if { ($host_header equals "gift-rewards.interswitch.com" ) } {
        #pool prod_ingress_node_pool
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        return
      }
       if { ($host_header equals "consumer-rewards.interswitch.com" ) } {
        #pool prod_ingress_node_pool
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        return
      }
       if { ($host_header equals "code-rewards.interswitch.com" ) } {
        #pool prod_ingress_node_pool
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        return
      }
       if { ($host_header equals "user-rewards.interswitch.com" ) } {
        #pool prod_ingress_node_pool
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        return
      }
         if { ($host_header equals "campaign-rewards.interswitch.com" ) } {
        #pool prod_ingress_node_pool
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        return
      }
         if { ($host_header equals "csv-rewards.interswitch.com" ) } {
        #pool prod_ingress_node_pool
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        return
      }
         if { ($host_header equals "auditlogs-rewards.interswitch.com" ) } {
        #pool prod_ingress_node_pool
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        return
      }


      if { ($host_header equals "rewards.interswitch.com") } {
        #pool prod_ingress_node_pool
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        return
      }



      if { ($host_header equals "hims.interswitchng.com") } {
        switch -glob $uri_info {
	        "/hims/api/*" {
		        #pool hims-middleware_default_k8_prod
		        return
	        }
        	"/*" {
	        #	pool hims-frontend_default_k8_prod
	        }	
        }
      }

      if { ($host_header equals "kmw.interswitchng.com") } {
        pool pool_merchant_x
      }

      if { ($host_header equals "api-gateway.interswitchng.com") } {
        #pool api-gateway-mangement-pool
        #pool prod_ingress_node_pool
        #pool api-management-gateway_default_k8_prod
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        return

        # switch -glob $uri_info {

        #     "/api/v1/safetoken"  {
        #         HTTP::header replace Host "api-gateway-prod.k2.isw.la"
        #         pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        #         return
        #     }

        #     "/api/v1/safetoken*" {
        #       HTTP::header replace Host "api-management-gateway-prod.ingress.isw.la"
        #       pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        #       return
        #     }

        #     "/api/v1/*" {
        #       HTTP::header replace Host "api-management-gateway-prod.ingress.isw.la"
        #       pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        #       return
        #     }

        #     "*" {
        #       pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        #       return
        #     }

        # }
      }
      if { [string tolower [HTTP::host]] equals "www.developer.interswitchgroup.com" } {
        HTTP::redirect "https://developer.interswitchgroup.com[HTTP::uri]"
        return
      }

      if { ($host_header equals "bifrostportalapi.qa.interswitchng.com") } {
        node 172.26.41.185 4100
      }

      if { ($host_header equals "bifrostportalapi.interswitchng.com") } {
        node 172.35.14.227 4100
      # node 172.35.8.36 4100
      }

      if { ($host_header equals "vervemobile.ng") } {
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
      }
      
      if { ($host_header equals "staff.vervemobile.ng") } {
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
      } 
      
      if { ($host_header equals "api.vervemobile.ng") } {
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
      }

      if { ($host_header equals "bifrostmfb-v2.interswitchng.com") } {
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
      }

      if { ($host_header equals "bifrostportal-v2.interswitchng.com") } {
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
      }
      
      if { ($host_header equals "credit-card-mw.interswitchng.com") } {
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
      }
      if { ($host_header equals "hosted-fields-tokenization.interswitchng.com") } {
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
      }
      if { ($host_header equals "kyc.interswitchgroup.com") } {
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
      }

      if { ($host_header equals "hims.interswitchgroup.com") } {
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
      }

      if { ($host_header equals "hims-be.interswitchgroup.com") } {
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
      }
         
      if { ($host_header equals "staffonboarding.interswitchgroup.com") } {
        pool mendix-cluster-nodes
      }

      if { ($host_header equals "paymentportal.interswitchgroup.com") } {
        node 172.35.8.120 80
      }

      if { ($host_header equals "smartmove.interswitchgroup.com") } {
        #pool smartmove_default_k8_prod
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
      }

      if { ($host_header equals "loyalty-service.interswitchng.com") } {
       # pool loyalty-service_default_k8_prod
      }
      if { ($host_header equals "ils-hosted-fields-channel-providers.interswitchng.com") } {
       # pool ils-hosted-fields-channel-providers_default_k8_prod
      }      
      if { ($host_header equals "ils-hosted-fields-channels.interswitchng.com") } {
       # pool ils-hosted-fields-channels_default_k8_prod
      }


     if { ($host_header equals "vcas-rdx.interswitchng.com") } {
        # pool vcas-rdx-service_default_k8_prod
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
      }

      if { ($host_header equals "thingsboard.interswitchng.com") } {
         node 172.26.40.12 8080
      }

        if { ($host_header equals "paypoint.interswitchgroup.com")} {	   
		switch -glob $uri_info {

			"/api/v2/finch-transaction/payments/initializ*" {

             #pool finch-transaction-service_default_k8_prod
             pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
           }
		    "/api/v2/finch-transaction/payments/proceed*" {

             #pool finch-transaction-service_default_k8_prod
             pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
           }
           "*" {

             #pool finch-agent-dashboard_default_k8_prod
             pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress

           }
         }
       }

      if { ($host_header equals "business.interswitchgroup.com")} {	   
		switch -glob $uri_info {

			"/link*" {
				HTTP::uri [string map {"/link" "/paymentgateway/link"} [HTTP::uri]]
				#pool 	project-x-merchant_default_k8_prod
				#pool prod_ingress_node_pool
			}

			"/invoice*" {
				HTTP::uri [string map {"/invoice" "/paymentgateway/invoice"} [HTTP::uri]]
				#pool 	project-x-merchant_default_k8_prod
				#pool prod_ingress_node_pool
			}

			"/*" {
				# pool 	quickteller-merchant-ui_default_k8_prod
				pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
           }



		}
  

  } 
}


when HTTP_RESPONSE {
  if { ($host_header equals "mufasa.interswitchng.com") } {
    set cookieNames [HTTP::cookie names]
    foreach aCookie $cookieNames {
      HTTP::cookie remove $aCookie
    }

    HTTP::header insert Expires "[clock format [expr {([clock seconds]+86400)}] -format "%a, %d %h %Y %T GMT" -gmt true]"
    HTTP::header insert Access-Control-Allow-Origin "https://portal.interswitchng.com"
    HTTP::header insert Access-Control-Allow-Origin "https://portal.interswitchgroup.com"
    HTTP::header insert Access-Control-Allow-Origin "https://v2-portal.interswitchng.com"
  }

  set port [TCP::remote_port]
  set location_header [HTTP::header value Location]


}