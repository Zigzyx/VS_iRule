when HTTP_REQUEST {
    if { [HTTP::has_responded] } { return };
    set host_header [string tolower [HTTP::host]]
    set uri_info [string tolower [HTTP::uri]]
    set remote [IP::remote_addr]
    set method [HTTP::method]
    #SSL::disable serverside
    persist none


    switch -glob $uri_info {
        "/ptsp*" {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
        }

        "/payouts*" {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
        }
        "/isw-payout-reporting*" {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
        }
        "/imto*" {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
        }
    }
    #if { [HTTP::uri] starts_with "/socket.io/" } {
            #pool isw-socket-2223
            #return
    #}
    
    if { ($host_header equals "mufasa.interswitchng.com") } {
        if { [HTTP::uri] starts_with "/p/passport" } {
            set uri [string map -nocase {"/p/passport" "/p/passporti"} [HTTP::uri]]
            HTTP::uri $uri
        }
        pool mufasa_static_pool
        return
    }   

    if { ($host_header equals "qtt-payment-api.interswitchng.com") } {
      pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
      return
    }
    
    if { ($host_header equals "homes-webapi.interswitchgroup.com") } {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
      }
     
    #if { ($host_header equals "helper.interswitchgroup.com") } {
         # node 172.16.10.72 5173
         # return
      #}
    if { $host_header eq "helper.interswitchgroup.com" } {
          HTTP::respond 301 \
            Location "https://help-uat.interswitchgroup.com"
          return
        }
    if { ($host_header equals "help-uat.interswitchgroup.com") } {
         node 172.16.10.72 5173
         return
        }
    
    if { ($host_header equals "smartfuel-payments.interswitchng.com") } {
      pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
      return
    }      
    if { ($host_header equals "api.dreamskyafrica.com") } {
      pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
      return
    }
    if { ($host_header equals "lifesaver.eclathealthcare.com") } {
      pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
      return
    }

    if { ($host_header equals "eclinic.interswitchng.com") } {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
       }
    
    if { ($host_header equals "api-marketplace-routing.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
    }
    if { ($host_header equals "marketplace-routing-middleware-kyc.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
    }
    if { ($host_header equals "api-marketplace.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
    }
    if { ($host_header equals "api-marketplace-ui.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
    }
    if { ($host_header equals "marketplace-routing-middleware-sms.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
    } 
    if { ($host_header equals "vtucare-webhook.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
    }
    if { ($host_header equals "wallets.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
    }
    if { ($host_header equals "developer.interswitchgroup.com") } {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
      }

    if { ($host_header equals "quickteller-merchant-ui.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
    }

    if { ($host_header equals "quickteller-sva.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
    }

    if { ($host_header equals "quickenergy.interswitchgroup.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
    }
    if { ($host_header equals "channels-rewards.interswitchng.com" ) } {
      pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
      return
    }
    if { ($host_header equals "redemption-rewards.interswitchng.com" ) } {
      pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
      return
    }
      if { ($host_header equals "gift-rewards.interswitchng.com" ) } {
      pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
      return
    }
    if { ($host_header equals "approval-rewards.interswitchng.com" ) } {
      pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
      return
    }    
      if { ($host_header equals "consumer-rewards.interswitchng.com" ) } {
      pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
      return
    }
      if { ($host_header equals "code-rewards.interswitchng.com" ) } {
      pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
      return
    }
      if { ($host_header equals "user-rewards.interswitchng.com" ) } {
      pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
      return
    }
        if { ($host_header equals "campaign-rewards.interswitchng.com" ) } {
      pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
      return
    }
        if { ($host_header equals "csv-rewards.interswitchng.com" ) } {
      pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
      return
    }

        if { ($host_header equals "auditlogs-rewards.interswitchng.com" ) } {
      pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
      return
    }
    if { ($host_header equals "rewards.interswitchng.com") } {
      #pool prod_ingress_node_pool
      pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
      return
    }
        if { ($host_header equals "cards360-api.interswitchng.com" ) } {
      pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
      return
    }

        if { ($host_header equals "smartid.interswitch.com" ) } {
      pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
      return
    }
    
        if { ($host_header equals "smartid-service.interswitch.com" ) } {
      pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
      return
      }

    if { ($host_header equals "socket.interswitchng.com") } {
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
      }
    
    if { ($host_header equals "pilot-socket.interswitchng.com") } {
        pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
      }

    if { ($host_header equals "merchantreporting.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
    }
    if { ($host_header equals "nsw.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
    }
    
    if { ($host_header equals "billpurchase.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
    }
    
    if { ($host_header equals "oyocollections.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
    }

    if { ($host_header equals "mrsp.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
    }

    if { ($host_header equals "webpay-portal.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
    }           

    if { ($host_header equals "smarthealth.interswitchgroup.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
    }

    if { ($host_header equals "smarthealthapi.interswitchgroup.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
    }

    if { ($host_header equals "eclinicsmtp.interswitchgroup.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
    }

    if { ($host_header equals "paymenthubapi.interswitchgroup.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
    }

    if { ($host_header equals "marketing.interswitchgroup.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
    }

    if { ($host_header equals "marketing.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
    }

    if { ($host_header equals "oneview-admin.interswitchgroup.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
    }

    if { ($host_header equals "lighthouse.interswitchng.com") } {
      pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
      return 
    }

    if { ($host_header equals "eclinicmdi.interswitchng.com") } {
            pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
            return
    }  

     if { ($host_header equals "nigeriarevenuesummit.com") } {
            node 172.35.16.137 80
            return
    }

   if { ($host_header equals "uat-help.interswitchgroup.com") } {
            node  172.16.10.121 5173
            return
    }

    if { ($host_header equals "eclinic-pilot.interswitchng.com") } {
          pool /cis/Shared/nginx_ingress_controller_80_nginx_ingress
          return
       }

    if { ($host_header equals "quickteller-streamlit-portal.interswitchng.com") } {
        if { [HTTP::uri] starts_with "/transactionportal" } {
        # Route to port 8501 for any /transactionportal path
            node 172.31.2.57 8501 
            return
        }


        if { [HTTP::uri] starts_with "/failedtransaction" } {
        # Route to port 8502 for any /failedtransaction path
            node 172.31.2.57 8502 
            return
        }

        if { [HTTP::uri] starts_with "/customercare" } {
        # Route to port 8502 for any /customercare path
            node 172.31.2.57 8503 
            return
        }


    }

    if { ($host_header equals "dynamicsapi.interswitchgroup.com") } {
            SSL::disable serverside
            pool dynamics_api_pool
            return
    }

    
}

when HTTP_RESPONSE {

  set port [TCP::remote_port]
  set location_header [HTTP::header value Location]

}
