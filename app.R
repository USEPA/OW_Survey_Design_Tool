packages <- c("shiny", "spsurvey", "janitor", "DT", "zip", "foreign", "sf", "leaflet", "mapview", "ggspatial", "bslib", "shinybusy", 
              "shinycssloaders", "shinyhelper", "shinyBS", "dplyr", "ggplot2", "purrr", "tidyr", "stringr", "shinyjs")
#installed_packages <- packages %in% rownames(installed.packages())
#if(any(installed_packages == FALSE)) {
#  install.packages(packages[!installed_packages])
#}


# Packages loading
lapply(packages, library, character.only = TRUE)

rseed <- sample(10000,1)
#state_name <- state.name

#Allows the upload of large files
options(shiny.maxRequestSize = 10000*1024^2)
#Creates new operator %!in%
`%!in%` <- Negate(`%in%`)

####EPA Template####
# Define UI
ui <- div(fixedPage(theme=bs_theme(version=3, bootswatch="yeti"), 
                    tags$html(class = "no-js", lang="en"),
                    useShinyjs(),
                    tags$head(
                      tags$style(
                        #Controls tabsetPanel display
                      HTML(".nav:not(.nav-hidden) {
                            display: block !important;
                            }")),
                      HTML(
                        "<!-- Google Tag Manager -->
		<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
		new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
		j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
		'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
		})(window,document,'script','dataLayer','GTM-L8ZB');</script>
		<!-- End Google Tag Manager -->
		"
                      ),
		tags$meta(charset="utf-8"),
		tags$meta(property="og:site_name", content="US EPA"),
		#tags$link(rel = "stylesheet", type = "text/css", href = "css/uswds.css"),
		tags$link(rel = "stylesheet", type = "text/css", href = "https://cdnjs.cloudflare.com/ajax/libs/uswds/3.0.0-beta.3/css/uswds.min.css", integrity="sha512-ZKvR1/R8Sgyx96aq5htbFKX84hN+zNXN73sG1dEHQTASpNA8Pc53vTbPsEKTXTZn9J4G7R5Il012VNsDEReqCA==", crossorigin="anonymous", referrerpolicy="no-referrer"),
		tags$meta(property="og:url", content="https://www.epa.gov/themes/epa_theme/pattern-lab/.markup-only.html"),
		tags$link(rel="canonical", href="https://www.epa.gov/themes/epa_theme/pattern-lab/.markup-only.html"),
		tags$link(rel="shortlink", href="https://www.epa.gov/themes/epa_theme/pattern-lab/.markup-only.html"),
		tags$meta(property="og:url", content="https://www.epa.gov/themes/epa_theme/pattern-lab/.markup-only.html"),
		tags$meta(property="og:image", content="https://www.epa.gov/sites/all/themes/epa/img/epa-standard-og.jpg"),
		tags$meta(property="og:image:width", content="1200"),
		tags$meta(property="og:image:height", content="630"),
		tags$meta(property="og:image:alt", content="U.S. Environmental Protection Agency"),
		tags$meta(name="twitter:card", content="summary_large_image"),
		tags$meta(name="twitter:image:alt", content="U.S. Environmental Protection Agency"),
		tags$meta(name="twitter:image:height", content="600"),
		tags$meta(name="twitter:image:width", content="1200"),
		tags$meta(name="twitter:image", content="https://www.epa.gov/sites/all/themes/epa/img/epa-standard-twitter.jpg"),
		tags$meta(name="MobileOptimized", content="width"),
		tags$meta(name="HandheldFriendly", content="true"),
		tags$meta(name="viewport", content="width=device-width, initial-scale=1.0"),
		tags$meta(`http-equiv`="x-ua-compatible", content="ie=edge"),
		tags$script(src = "js/pattern-lab-head-script.js"),
		tags$title('Survey Design Tool | US EPA'),
		tags$link(rel="icon", type="image/x-icon", href="https://www.epa.gov/themes/epa_theme/images/favicon.ico"),
		tags$meta(name="msapplication-TileColor", content="#FFFFFF"),
		tags$meta(name="msapplication-TileImage", content="https://www.epa.gov/themes/epa_theme/images/favicon-144.png"),
		tags$meta(name="application-name", content=""),
		tags$meta(name="msapplication-config", content="https://www.epa.gov/themes/epa_theme/images/ieconfig.xml"),
		tags$link(rel="apple-touch-icon-precomposed", sizes="196x196", href="https://www.epa.gov/themes/epa_theme/images/favicon-196.png"),
		tags$link(rel="apple-touch-icon-precomposed", sizes="152x152", href="https://www.epa.gov/themes/epa_theme/images/favicon-152.png"),
		tags$link(rel="apple-touch-icon-precomposed", sizes="144x144", href="https://www.epa.gov/themes/epa_theme/images/favicon-144.png"),
		tags$link(rel="apple-touch-icon-precomposed", sizes="120x120", href="https://www.epa.gov/themes/epa_theme/images/favicon-120.png"),
		tags$link(rel="apple-touch-icon-precomposed", sizes="114x114", href="https://www.epa.gov/themes/epa_theme/images/favicon-114.png"),
		tags$link(rel="apple-touch-icon-precomposed", sizes="72x72", href="https://www.epa.gov/themes/epa_theme/images/favicon-72.png"),
		tags$link(rel="apple-touch-icon-precomposed", href="https://www.epa.gov/themes/epa_theme/images/favicon-180.png"),
		tags$link(rel="icon", href="https://www.epa.gov/themes/epa_theme/images/favicon-32.png", sizes="32x32"),
		tags$link(rel="preload", href="https://www.epa.gov/themes/epa_theme/fonts/source-sans-pro/sourcesanspro-regular-webfont.woff2", as="font", crossorigin="anonymous"),
		tags$link(rel="preload", href="https://www.epa.gov/themes/epa_theme/fonts/source-sans-pro/sourcesanspro-bold-webfont.woff2", as="font", crossorigin="anonymous"),
		tags$link(rel="preload", href="https://www.epa.gov/themes/epa_theme/fonts/merriweather/Latin-Merriweather-Bold.woff2", as="font", crossorigin="anonymous"),
		tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/core/themes/stable/css/system/components/ajax-progress.module.css?r6lsex"),
		tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/core/themes/stable/css/system/components/autocomplete-loading.module.css?r6lsex" ),
		tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/core/themes/stable/css/system/components/js.module.css?r6lsex"),
		tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/core/themes/stable/css/system/components/sticky-header.module.css?r6lsex"),
		tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/core/themes/stable/css/system/components/system-status-counter.css?r6lsex"),
		tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/core/themes/stable/css/system/components/system-status-report-counters.css?r6lsex"),
		tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/core/themes/stable/css/system/components/system-status-report-general-info.css?r6lsex"),
		tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/core/themes/stable/css/system/components/tabledrag.module.css?r6lsex"),
		tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/core/themes/stable/css/system/components/tablesort.module.css?r6lsex"),
		tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/core/themes/stable/css/system/components/tree-child.module.css?r6lsex"),
		tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/themes/epa_theme/css/styles.css?r6lsex"),
		tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/themes/epa_theme/css-lib/colorbox.min.css?r6lsex"),
		
		tags$script(src = 'https://cdnjs.cloudflare.com/ajax/libs/uswds/3.0.0-beta.3/js/uswds-init.min.js'),
		#fix container-fluid that boostrap RShiny uses
		tags$style(HTML(
		  '.container-fluid {
            padding-right: 0;
            padding-left: 0;
            margin-right: 0;
            margin-left: 0;
        }
        .tab-content {
            margin-right: 30px;
            margin-left: 30px;
        }'
		))
                    ),
		tags$body(
		  class="path-themes not-front has-wide-template", id="top",
		  tags$script(
		    src = 'https://cdnjs.cloudflare.com/ajax/libs/uswds/3.0.0-beta.3/js/uswds.min.js'
		  )
		),
		
		# Site Header
		HTML(
		  '<div class="skiplinks" role="navigation" aria-labelledby="skip-to-main">
      <a id="skip-to-main" href="#main" class="skiplinks__link visually-hidden focusable">Skip to main content</a>
    </div>

	<!-- Google Tag Manager (noscript) -->
	<noscript><iframe src=https://www.googletagmanager.com/ns.html?id=GTM-L8ZB
	height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
	<!-- End Google Tag Manager (noscript) -->

    <div class="dialog-off-canvas-main-canvas" data-off-canvas-main-canvas>
    <section class="usa-banner" aria-label="Official government website">
      <div class="usa-accordion">
        <header class="usa-banner__header">
          <div class="usa-banner__inner">
            <div class="grid-col-auto">
              <img class="usa-banner__header-flag" src="https://www.epa.gov/themes/epa_theme/images/us_flag_small.png" alt="U.S. flag" />
            </div>
            <div class="grid-col-fill tablet:grid-col-auto">
              <p class="usa-banner__header-text">An official website of the United States government</p>
              <p class="usa-banner__header-action" aria-hidden="true">Here’s how you know</p>
            </div>
            <button class="usa-accordion__button usa-banner__button" aria-expanded="false" aria-controls="gov-banner">
              <span class="usa-banner__button-text">Here’s how you know</span>
            </button>
          </div>
        </header>
        <div class="usa-banner__content usa-accordion__content" id="gov-banner">
          <div class="grid-row grid-gap-lg">
            <div class="usa-banner__guidance tablet:grid-col-6">
              <img class="usa-banner__icon usa-media-block__img" src="https://www.epa.gov/themes/epa_theme/images/icon-dot-gov.svg" alt="Dot gov">
              <div class="usa-media-block__body">
                <p>
                  <strong>Official websites use .gov</strong>
                  <br> A <strong>.gov</strong> website belongs to an official government organization in the United States.
                </p>
              </div>
            </div>
            <div class="usa-banner__guidance tablet:grid-col-6">
              <img class="usa-banner__icon usa-media-block__img" src="https://www.epa.gov/themes/epa_theme/images/icon-https.svg" alt="HTTPS">
              <div class="usa-media-block__body">
                <p>
                  <strong>Secure .gov websites use HTTPS</strong>
                  <br> A <strong>lock</strong> (<span class="icon-lock"><svg xmlns="http://www.w3.org/2000/svg" width="52" height="64" viewBox="0 0 52 64" class="usa-banner__lock-image" role="img" aria-labelledby="banner-lock-title banner-lock-description"><title id="banner-lock-title">Lock</title><desc id="banner-lock-description">A locked padlock</desc><path fill="#000000" fill-rule="evenodd" d="M26 0c10.493 0 19 8.507 19 19v9h3a4 4 0 0 1 4 4v28a4 4 0 0 1-4 4H4a4 4 0 0 1-4-4V32a4 4 0 0 1 4-4h3v-9C7 8.507 15.507 0 26 0zm0 8c-5.979 0-10.843 4.77-10.996 10.712L15 19v9h22v-9c0-6.075-4.925-11-11-11z"/></svg></span>) or <strong>https://</strong> means you’ve safely connected to the .gov website. Share sensitive information only on official, secure websites.
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
    <div>
      <div class="js-view-dom-id-epa-alerts--public">
        <noscript>
          <div class="usa-site-alert usa-site-alert--info">
            <div class="usa-alert">
              <div class="usa-alert__body">
                <div class="usa-alert__text">
                  <p>JavaScript appears to be disabled on this computer. Please <a href="/alerts">click here to see any active alerts</a>.</p>
                </div>
              </div>
            </div>
          </div>
        </noscript>
      </div>
    </div>
    <header class="l-header">
      <div class="usa-overlay"></div>
      <div class="l-constrain">
        <div class="l-header__navbar">
          <div class="l-header__branding">
            <a class="site-logo" href="/" aria-label="Home" title="Home" rel="home">
              <span class="site-logo__image">
                <svg class="site-logo__svg" viewBox="0 0 1061 147" aria-hidden="true" xmlns="http://www.w3.org/2000/svg">
                  <path d="M112.8 53.5C108 72.1 89.9 86.8 69.9 86.8c-20.1 0-38-14.7-42.9-33.4h.2s9.8 10.3-.2 0c3.1 3.1 6.2 4.4 10.7 4.4s7.7-1.3 10.7-4.4c3.1 3.1 6.3 4.5 10.9 4.4 4.5 0 7.6-1.3 10.7-4.4 3.1 3.1 6.2 4.4 10.7 4.4 4.5 0 7.7-1.3 10.7-4.4 3.1 3.1 6.3 4.5 10.9 4.4 4.3 0 7.4-1.2 10.5-4.3zM113.2 43.5c0-24-19.4-43.5-43.3-43.5-24 0-43.5 19.5-43.5 43.5h39.1c-4.8-1.8-8.1-6.3-8.1-11.6 0-7 5.7-12.5 12.5-12.5 7 0 12.7 5.5 12.7 12.5 0 5.2-3.1 9.6-7.6 11.6h38.2zM72.6 139.3c.7-36.9 29.7-68.8 66.9-70 0 37.2-30 68-66.9 70zM67.1 139.3c-.7-36.9-29.7-68.8-67.1-70 0 37.2 30.2 68 67.1 70zM240 3.1h-87.9v133.1H240v-20.4h-60.3v-36H240v-21h-60.3v-35H240V3.1zM272.8 58.8h27.1c9.1 0 15.2-8.6 15.1-17.7-.1-9-6.1-17.3-15.1-17.3h-25.3v112.4h-27.8V3.1h62.3c20.2 0 35 17.8 35.2 38 .2 20.4-14.8 38.7-35.2 38.7h-36.3v-21zM315.9 136.2h29.7l12.9-35h54.2l-8.1-21.9h-38.4l18.9-50.7 39.2 107.6H454L400.9 3.1h-33.7l-51.3 133.1zM473.3.8v22.4c0 1.9.2 3.3.5 4.3s.7 1.7 1 2.2c1.2 1.4 2.5 2.4 3.9 2.9 1.5.5 2.8.7 4.1.7 2.4 0 4.2-.4 5.5-1.3 1.3-.8 2.2-1.8 2.8-2.9.6-1.1.9-2.3 1-3.4.1-1.1.1-2 .1-2.6V.8h4.7v24c0 .7-.1 1.5-.4 2.4-.3 1.8-1.2 3.6-2.5 5.4-1.8 2.1-3.8 3.5-6 4.2-2.2.6-4 .9-5.3.9-1.8 0-3.8-.3-6.2-1.1-2.4-.8-4.5-2.3-6.2-4.7-.5-.8-1-1.8-1.4-3.2-.4-1.3-.6-3.3-.6-5.9V.8h5zM507.5 14.5v-2.9l4.6.1-.1 4.1c.2-.3.4-.7.8-1.2.3-.5.8-.9 1.4-1.4.6-.5 1.4-.9 2.3-1.3.9-.3 2.1-.5 3.4-.4.6 0 1.4.1 2.4.3.9.2 1.9.6 2.9 1.2s1.8 1.5 2.4 2.6c.6 1.2.9 2.8.9 4.7l-.4 17-4.6-.1.4-16c0-.9 0-1.7-.2-2.4-.1-.7-.5-1.3-1.1-1.9-1.2-1.2-2.6-1.8-4.3-1.8-1.7 0-3.1.5-4.4 1.7-1.3 1.2-2 3.1-2.1 5.7l-.3 14.5-4.5-.1.5-22.4zM537.2.9h5.5V6h-5.5V.9m.5 10.9h4.6v25.1h-4.6V11.8zM547.8 11.7h4.3V6.4l4.5-1.5v6.8h5.4v3.4h-5.4v15.1c0 .3 0 .6.1 1 0 .4.1.7.4 1.1.2.4.5.6 1 .8.4.3 1 .4 1.8.4 1 0 1.7-.1 2.2-.2V37c-.9.2-2.1.3-3.8.3-2.1 0-3.6-.4-4.6-1.2-1-.8-1.5-2.2-1.5-4.2V15.1h-4.3v-3.4zM570.9 25.2c-.1 2.6.5 4.8 1.7 6.5 1.1 1.7 2.9 2.6 5.3 2.6 1.5 0 2.8-.4 3.9-1.3 1-.8 1.6-2.2 1.8-4h4.6c0 .6-.2 1.4-.4 2.3-.3 1-.8 2-1.7 3-.2.3-.6.6-1 1-.5.4-1 .7-1.7 1.1-.7.4-1.5.6-2.4.8-.9.3-2 .4-3.3.4-7.6-.2-11.3-4.5-11.3-12.9 0-2.5.3-4.8 1-6.8s2-3.7 3.8-5.1c1.2-.8 2.4-1.3 3.7-1.6 1.3-.2 2.2-.3 3-.3 2.7 0 4.8.6 6.3 1.6s2.5 2.3 3.1 3.9c.6 1.5 1 3.1 1.1 4.6.1 1.6.1 2.9 0 4h-17.5m12.9-3v-1.1c0-.4 0-.8-.1-1.2-.1-.9-.4-1.7-.8-2.5s-1-1.5-1.8-2c-.9-.5-2-.8-3.4-.8-.8 0-1.5.1-2.3.3-.8.2-1.5.7-2.2 1.3-.7.6-1.2 1.3-1.6 2.3-.4 1-.7 2.2-.8 3.6h13zM612.9.9h4.6V33c0 1 .1 2.3.2 4h-4.6l-.1-4c-.2.3-.4.7-.7 1.2-.3.5-.8 1-1.4 1.5-1 .7-2 1.2-3.1 1.4l-1.5.3c-.5.1-.9.1-1.4.1-.4 0-.8 0-1.3-.1s-1.1-.2-1.7-.3c-1.1-.3-2.3-.9-3.4-1.8s-2.1-2.2-2.9-3.8c-.8-1.7-1.2-3.9-1.2-6.6.1-4.8 1.2-8.3 3.4-10.5 2.1-2.1 4.7-3.2 7.6-3.2 1.3 0 2.4.2 3.4.5.9.3 1.6.7 2.2 1.2.6.4 1 .9 1.3 1.4.3.5.6.8.7 1.1V.9m0 23.1c0-1.9-.2-3.3-.5-4.4-.4-1.1-.8-2-1.4-2.6-.5-.7-1.2-1.3-2-1.8-.9-.5-2-.7-3.3-.7-1.7 0-2.9.5-3.8 1.3-.9.8-1.6 1.9-2 3.1-.4 1.2-.7 2.3-.7 3.4-.1 1.1-.2 1.9-.1 2.4 0 1.1.1 2.2.3 3.4.2 1.1.5 2.2 1 3.1.5 1 1.2 1.7 2 2.3.9.6 2 .9 3.3.9 1.8 0 3.2-.5 4.2-1.4 1-.8 1.7-1.8 2.1-3 .4-1.2.7-2.4.8-3.4.1-1.4.1-2.1.1-2.6zM643.9 26.4c0 .6.1 1.3.3 2.1.1.8.5 1.6 1 2.3.5.8 1.4 1.4 2.5 1.9s2.7.8 4.7.8c1.8 0 3.3-.3 4.4-.8 1.1-.5 1.9-1.1 2.5-1.8.6-.7 1-1.5 1.1-2.2.1-.7.2-1.2.2-1.7 0-1-.2-1.9-.5-2.6-.4-.6-.9-1.2-1.6-1.6-1.4-.8-3.4-1.4-5.9-2-4.9-1.1-8.1-2.2-9.5-3.2-1.4-1-2.3-2.2-2.9-3.5-.6-1.2-.8-2.4-.8-3.6.1-3.7 1.5-6.4 4.2-8.1 2.6-1.7 5.7-2.5 9.1-2.5 1.3 0 2.9.2 4.8.5 1.9.4 3.6 1.4 5 3 .5.5.9 1.1 1.2 1.7.3.5.5 1.1.6 1.6.2 1.1.3 2.1.3 2.9h-5c-.2-2.2-1-3.7-2.4-4.5-1.5-.7-3.1-1.1-4.9-1.1-5.1.1-7.7 2-7.8 5.8 0 1.5.5 2.7 1.6 3.5 1 .8 2.6 1.4 4.7 1.9 4 1 6.7 1.8 8.1 2.2.8.2 1.4.5 1.8.7.5.2 1 .5 1.4.9.8.5 1.4 1.1 1.9 1.8s.8 1.4 1.1 2.1c.3 1.4.5 2.5.5 3.4 0 3.3-1.2 6-3.5 8-2.3 2.1-5.8 3.2-10.3 3.3-1.4 0-3.2-.3-5.4-.8-1-.3-2-.7-3-1.2-.9-.5-1.8-1.2-2.5-2.1-.9-1.4-1.5-2.7-1.7-4.1-.3-1.3-.4-2.4-.3-3.2h5zM670 11.7h4.3V6.4l4.5-1.5v6.8h5.4v3.4h-5.4v15.1c0 .3 0 .6.1 1 0 .4.1.7.4 1.1.2.4.5.6 1 .8.4.3 1 .4 1.8.4 1 0 1.7-.1 2.2-.2V37c-.9.2-2.1.3-3.8.3-2.1 0-3.6-.4-4.6-1.2-1-.8-1.5-2.2-1.5-4.2V15.1H670v-3.4zM705.3 36.9c-.3-1.2-.5-2.5-.4-3.7-.5 1-1.1 1.8-1.7 2.4-.7.6-1.4 1.1-2 1.4-1.4.5-2.7.8-3.7.8-2.8 0-4.9-.8-6.4-2.2-1.5-1.4-2.2-3.1-2.2-5.2 0-1 .2-2.3.8-3.7.6-1.4 1.7-2.6 3.5-3.7 1.4-.7 2.9-1.2 4.5-1.5 1.6-.1 2.9-.2 3.9-.2s2.1 0 3.3.1c.1-2.9-.2-4.8-.9-5.6-.5-.6-1.1-1.1-1.9-1.3-.8-.2-1.6-.4-2.3-.4-1.1 0-2 .2-2.6.5-.7.3-1.2.7-1.5 1.2-.3.5-.5.9-.6 1.4-.1.5-.2.9-.2 1.2h-4.6c.1-.7.2-1.4.4-2.3.2-.8.6-1.6 1.3-2.5.5-.6 1-1 1.7-1.3.6-.3 1.3-.6 2-.8 1.5-.4 2.8-.6 4.2-.6 1.8 0 3.6.3 5.2.9 1.6.6 2.8 1.6 3.4 2.9.4.7.6 1.4.7 2 .1.6.1 1.2.1 1.8l-.2 12c0 1 .1 3.1.4 6.3h-4.2m-.5-12.1c-.7-.1-1.6-.1-2.6-.1h-2.1c-1 .1-2 .3-3 .6s-1.9.8-2.6 1.5c-.8.7-1.2 1.7-1.2 3 0 .4.1.8.2 1.3s.4 1 .8 1.5.9.8 1.6 1.1c.7.3 1.5.5 2.5.5 2.3 0 4.1-.9 5.2-2.7.5-.8.8-1.7 1-2.7.1-.9.2-2.2.2-4zM714.5 11.7h4.3V6.4l4.5-1.5v6.8h5.4v3.4h-5.4v15.1c0 .3 0 .6.1 1 0 .4.1.7.4 1.1.2.4.5.6 1 .8.4.3 1 .4 1.8.4 1 0 1.7-.1 2.2-.2V37c-.9.2-2.1.3-3.8.3-2.1 0-3.6-.4-4.6-1.2-1-.8-1.5-2.2-1.5-4.2V15.1h-4.3v-3.4zM737.6 25.2c-.1 2.6.5 4.8 1.7 6.5 1.1 1.7 2.9 2.6 5.3 2.6 1.5 0 2.8-.4 3.9-1.3 1-.8 1.6-2.2 1.8-4h4.6c0 .6-.2 1.4-.4 2.3-.3 1-.8 2-1.7 3-.2.3-.6.6-1 1-.5.4-1 .7-1.7 1.1-.7.4-1.5.6-2.4.8-.9.3-2 .4-3.3.4-7.6-.2-11.3-4.5-11.3-12.9 0-2.5.3-4.8 1-6.8s2-3.7 3.8-5.1c1.2-.8 2.4-1.3 3.7-1.6 1.3-.2 2.2-.3 3-.3 2.7 0 4.8.6 6.3 1.6s2.5 2.3 3.1 3.9c.6 1.5 1 3.1 1.1 4.6.1 1.6.1 2.9 0 4h-17.5m12.9-3v-1.1c0-.4 0-.8-.1-1.2-.1-.9-.4-1.7-.8-2.5s-1-1.5-1.8-2c-.9-.5-2-.8-3.4-.8-.8 0-1.5.1-2.3.3-.8.2-1.5.7-2.2 1.3-.7.6-1.2 1.3-1.6 2.3-.4 1-.7 2.2-.8 3.6h13zM765.3 29.5c0 .5.1 1 .2 1.4.1.5.4 1 .8 1.5s.9.8 1.6 1.1c.7.3 1.6.5 2.7.5 1 0 1.8-.1 2.5-.3.7-.2 1.3-.6 1.7-1.2.5-.7.8-1.5.8-2.4 0-1.2-.4-2-1.3-2.5s-2.2-.9-4.1-1.2c-1.3-.3-2.4-.6-3.6-1-1.1-.3-2.1-.8-3-1.3-.9-.5-1.5-1.2-2-2.1-.5-.8-.8-1.9-.8-3.2 0-2.4.9-4.2 2.6-5.6 1.7-1.3 4-2 6.8-2.1 1.6 0 3.3.3 5 .8 1.7.6 2.9 1.6 3.7 3.1.4 1.4.6 2.6.6 3.7h-4.6c0-1.8-.6-3-1.7-3.5-1.1-.4-2.1-.6-3.1-.6h-1c-.5 0-1.1.2-1.7.4-.6.2-1.1.5-1.5 1.1-.5.5-.7 1.2-.7 2.1 0 1.1.5 1.9 1.3 2.3.7.4 1.5.7 2.1.9 3.3.7 5.6 1.3 6.9 1.8 1.3.4 2.2 1 2.8 1.7.7.7 1.1 1.4 1.4 2.2.3.8.4 1.6.4 2.5 0 1.4-.3 2.7-.9 3.8-.6 1.1-1.4 2-2.4 2.6-1.1.6-2.2 1-3.4 1.3-1.2.3-2.5.4-3.8.4-2.5 0-4.7-.6-6.6-1.8-1.8-1.2-2.8-3.3-2.9-6.3h5.2zM467.7 50.8h21.9V55h-17.1v11.3h16.3v4.2h-16.3v12.1H490v4.3h-22.3zM499 64.7l-.1-2.9h4.6v4.1c.2-.3.4-.8.7-1.2.3-.5.8-1 1.3-1.5.6-.5 1.4-1 2.3-1.3.9-.3 2-.5 3.4-.5.6 0 1.4.1 2.4.2.9.2 1.9.5 2.9 1.1 1 .6 1.8 1.4 2.5 2.5.6 1.2 1 2.7 1 4.7V87h-4.6V71c0-.9-.1-1.7-.2-2.4-.2-.7-.5-1.3-1.1-1.9-1.2-1.1-2.6-1.7-4.3-1.7-1.7 0-3.1.6-4.3 1.8-1.3 1.2-2 3.1-2 5.7V87H499V64.7zM524.6 61.8h5.1l7.7 19.9 7.6-19.9h5l-10.6 25.1h-4.6zM555.7 50.9h5.5V56h-5.5v-5.1m.5 10.9h4.6v25.1h-4.6V61.8zM570.3 67c0-1.8-.1-3.5-.3-5.1h4.6l.1 4.9c.5-1.8 1.4-3 2.5-3.7 1.1-.7 2.2-1.2 3.3-1.3 1.4-.2 2.4-.2 3.1-.1v4.6c-.2-.1-.5-.2-.9-.2h-1.3c-1.3 0-2.4.2-3.3.5-.9.4-1.5.9-2 1.6-.9 1.4-1.4 3.2-1.3 5.4v13.3h-4.6V67zM587.6 74.7c0-1.6.2-3.2.6-4.8.4-1.6 1.1-3 2-4.4 1-1.3 2.2-2.4 3.8-3.2 1.6-.8 3.6-1.2 5.9-1.2 2.4 0 4.5.4 6.1 1.3 1.5.9 2.7 2 3.6 3.3.9 1.3 1.5 2.8 1.8 4.3.2.8.3 1.5.4 2.2v2.2c0 3.7-1 6.9-3 9.5-2 2.6-5.1 4-9.3 4-4-.1-7-1.4-9-3.9-1.9-2.5-2.9-5.6-2.9-9.3m4.8-.3c0 2.7.6 5 1.8 6.9 1.2 2 3 3 5.6 3.1.9 0 1.8-.2 2.7-.5.8-.3 1.6-.9 2.3-1.7.7-.8 1.3-1.9 1.8-3.2.4-1.3.6-2.9.6-4.7-.1-6.4-2.5-9.6-7.1-9.6-.7 0-1.5.1-2.4.3-.8.3-1.7.8-2.5 1.6-.8.7-1.4 1.7-1.9 3-.6 1.1-.9 2.8-.9 4.8zM620.2 64.7l-.1-2.9h4.6v4.1c.2-.3.4-.8.7-1.2.3-.5.8-1 1.3-1.5.6-.5 1.4-1 2.3-1.3.9-.3 2-.5 3.4-.5.6 0 1.4.1 2.4.2.9.2 1.9.5 2.9 1.1 1 .6 1.8 1.4 2.5 2.5.6 1.2 1 2.7 1 4.7V87h-4.6V71c0-.9-.1-1.7-.2-2.4-.2-.7-.5-1.3-1.1-1.9-1.2-1.1-2.6-1.7-4.3-1.7-1.7 0-3.1.6-4.3 1.8-1.3 1.2-2 3.1-2 5.7V87h-4.6V64.7zM650 65.1l-.1-3.3h4.6v3.6c1.2-1.9 2.6-3.2 4.1-3.7 1.5-.4 2.7-.6 3.8-.6 1.4 0 2.6.2 3.6.5.9.3 1.7.7 2.3 1.1 1.1 1 1.9 2 2.3 3.1.2-.4.5-.8 1-1.3.4-.5.9-1 1.5-1.6.6-.5 1.5-.9 2.5-1.3 1-.3 2.2-.5 3.5-.5.9 0 1.9.1 3 .3 1 .2 2 .7 3 1.3 1 .6 1.7 1.5 2.3 2.7.6 1.2.9 2.7.9 4.6v16.9h-4.6V70.7c0-1.1-.1-2-.2-2.5-.1-.6-.3-1-.6-1.3-.4-.6-1-1.2-1.8-1.6-.8-.4-1.8-.6-3.1-.6-1.5 0-2.7.4-3.6 1-.4.3-.8.5-1.1.9l-.8.8c-.5.8-.8 1.8-1 2.8-.1 1.1-.2 2-.1 2.6v14.1h-4.6V70.2c0-1.6-.5-2.9-1.4-4-.9-1-2.3-1.5-4.2-1.5-1.6 0-2.9.4-3.8 1.1-.9.7-1.5 1.2-1.8 1.7-.5.7-.8 1.5-.9 2.5-.1.9-.2 1.8-.2 2.6v14.3H650V65.1zM700.5 75.2c-.1 2.6.5 4.8 1.7 6.5 1.1 1.7 2.9 2.6 5.3 2.6 1.5 0 2.8-.4 3.9-1.3 1-.8 1.6-2.2 1.8-4h4.6c0 .6-.2 1.4-.4 2.3-.3 1-.8 2-1.7 3-.2.3-.6.6-1 1-.5.4-1 .7-1.7 1.1-.7.4-1.5.6-2.4.8-.9.3-2 .4-3.3.4-7.6-.2-11.3-4.5-11.3-12.9 0-2.5.3-4.8 1-6.8s2-3.7 3.8-5.1c1.2-.8 2.4-1.3 3.7-1.6 1.3-.2 2.2-.3 3-.3 2.7 0 4.8.6 6.3 1.6s2.5 2.3 3.1 3.9c.6 1.5 1 3.1 1.1 4.6.1 1.6.1 2.9 0 4h-17.5m12.8-3v-1.1c0-.4 0-.8-.1-1.2-.1-.9-.4-1.7-.8-2.5s-1-1.5-1.8-2c-.9-.5-2-.8-3.4-.8-.8 0-1.5.1-2.3.3-.8.2-1.5.7-2.2 1.3-.7.6-1.2 1.3-1.6 2.3-.4 1-.7 2.2-.8 3.6h13zM725.7 64.7l-.1-2.9h4.6v4.1c.2-.3.4-.8.7-1.2.3-.5.8-1 1.3-1.5.6-.5 1.4-1 2.3-1.3.9-.3 2-.5 3.4-.5.6 0 1.4.1 2.4.2.9.2 1.9.5 2.9 1.1 1 .6 1.8 1.4 2.5 2.5.6 1.2 1 2.7 1 4.7V87h-4.6V71c0-.9-.1-1.7-.2-2.4-.2-.7-.5-1.3-1.1-1.9-1.2-1.1-2.6-1.7-4.3-1.7-1.7 0-3.1.6-4.3 1.8-1.3 1.2-2 3.1-2 5.7V87h-4.6V64.7zM752.3 61.7h4.3v-5.2l4.5-1.5v6.8h5.4v3.4h-5.4v15.1c0 .3 0 .6.1 1 0 .4.1.7.4 1.1.2.4.5.6 1 .8.4.3 1 .4 1.8.4 1 0 1.7-.1 2.2-.2V87c-.9.2-2.1.3-3.8.3-2.1 0-3.6-.4-4.6-1.2-1-.8-1.5-2.2-1.5-4.2V65.1h-4.3v-3.4zM787.6 86.9c-.3-1.2-.5-2.5-.4-3.7-.5 1-1.1 1.8-1.7 2.4-.7.6-1.4 1.1-2 1.4-1.4.5-2.7.8-3.7.8-2.8 0-4.9-.8-6.4-2.2-1.5-1.4-2.2-3.1-2.2-5.2 0-1 .2-2.3.8-3.7.6-1.4 1.7-2.6 3.5-3.7 1.4-.7 2.9-1.2 4.5-1.5 1.6-.1 2.9-.2 3.9-.2s2.1 0 3.3.1c.1-2.9-.2-4.8-.9-5.6-.5-.6-1.1-1.1-1.9-1.3-.8-.2-1.6-.4-2.3-.4-1.1 0-2 .2-2.6.5-.7.3-1.2.7-1.5 1.2-.3.5-.5.9-.6 1.4-.1.5-.2.9-.2 1.2h-4.6c.1-.7.2-1.4.4-2.3.2-.8.6-1.6 1.3-2.5.5-.6 1-1 1.7-1.3.6-.3 1.3-.6 2-.8 1.5-.4 2.8-.6 4.2-.6 1.8 0 3.6.3 5.2.9 1.6.6 2.8 1.6 3.4 2.9.4.7.6 1.4.7 2 .1.6.1 1.2.1 1.8l-.2 12c0 1 .1 3.1.4 6.3h-4.2m-.5-12.1c-.7-.1-1.6-.1-2.6-.1h-2.1c-1 .1-2 .3-3 .6s-1.9.8-2.6 1.5c-.8.7-1.2 1.7-1.2 3 0 .4.1.8.2 1.3s.4 1 .8 1.5.9.8 1.6 1.1c.7.3 1.5.5 2.5.5 2.3 0 4.1-.9 5.2-2.7.5-.8.8-1.7 1-2.7.1-.9.2-2.2.2-4zM800.7 50.9h4.6V87h-4.6zM828.4 50.8h11.7c2.1 0 3.9.1 5.5.4.8.2 1.5.4 2.2.9.7.4 1.3.9 1.8 1.6 1.7 1.9 2.6 4.2 2.6 7 0 2.7-.9 5.1-2.8 7.1-.8.9-2 1.7-3.6 2.2-1.6.6-3.9.9-6.9.9h-5.7V87h-4.8V50.8m4.8 15.9h5.8c.8 0 1.7-.1 2.6-.2.9-.1 1.8-.3 2.6-.7.8-.4 1.5-1 2-1.9.5-.8.8-2 .8-3.4s-.2-2.5-.7-3.3c-.5-.8-1.1-1.3-1.9-1.7-1.6-.5-3.1-.8-4.5-.7h-6.8v11.9zM858.1 67c0-1.8-.1-3.5-.3-5.1h4.6l.1 4.9c.5-1.8 1.4-3 2.5-3.7 1.1-.7 2.2-1.2 3.3-1.3 1.4-.2 2.4-.2 3.1-.1v4.6c-.2-.1-.5-.2-.9-.2h-1.3c-1.3 0-2.4.2-3.3.5-.9.4-1.5.9-2 1.6-.9 1.4-1.4 3.2-1.3 5.4v13.3H858V67zM875.5 74.7c0-1.6.2-3.2.6-4.8.4-1.6 1.1-3 2-4.4 1-1.3 2.2-2.4 3.8-3.2 1.6-.8 3.6-1.2 5.9-1.2 2.4 0 4.5.4 6.1 1.3 1.5.9 2.7 2 3.6 3.3.9 1.3 1.5 2.8 1.8 4.3.2.8.3 1.5.4 2.2v2.2c0 3.7-1 6.9-3 9.5-2 2.6-5.1 4-9.3 4-4-.1-7-1.4-9-3.9-1.9-2.5-2.9-5.6-2.9-9.3m4.8-.3c0 2.7.6 5 1.8 6.9 1.2 2 3 3 5.6 3.1.9 0 1.8-.2 2.7-.5.8-.3 1.6-.9 2.3-1.7.7-.8 1.3-1.9 1.8-3.2.4-1.3.6-2.9.6-4.7-.1-6.4-2.5-9.6-7.1-9.6-.7 0-1.5.1-2.4.3-.8.3-1.7.8-2.5 1.6-.8.7-1.4 1.7-1.9 3-.7 1.1-.9 2.8-.9 4.8zM904.1 61.7h4.3v-5.2l4.5-1.5v6.8h5.4v3.4h-5.4v15.1c0 .3 0 .6.1 1 0 .4.1.7.4 1.1.2.4.5.6 1 .8.4.3 1 .4 1.8.4 1 0 1.7-.1 2.2-.2V87c-.9.2-2.1.3-3.8.3-2.1 0-3.6-.4-4.6-1.2-1-.8-1.5-2.2-1.5-4.2V65.1h-4.3v-3.4zM927.2 75.2c-.1 2.6.5 4.8 1.7 6.5 1.1 1.7 2.9 2.6 5.3 2.6 1.5 0 2.8-.4 3.9-1.3 1-.8 1.6-2.2 1.8-4h4.6c0 .6-.2 1.4-.4 2.3-.3 1-.8 2-1.7 3-.2.3-.6.6-1 1-.5.4-1 .7-1.7 1.1-.7.4-1.5.6-2.4.8-.9.3-2 .4-3.3.4-7.6-.2-11.3-4.5-11.3-12.9 0-2.5.3-4.8 1-6.8s2-3.7 3.8-5.1c1.2-.8 2.4-1.3 3.7-1.6 1.3-.2 2.2-.3 3-.3 2.7 0 4.8.6 6.3 1.6s2.5 2.3 3.1 3.9c.6 1.5 1 3.1 1.1 4.6.1 1.6.1 2.9 0 4h-17.5m12.9-3v-1.1c0-.4 0-.8-.1-1.2-.1-.9-.4-1.7-.8-2.5s-1-1.5-1.8-2c-.9-.5-2-.8-3.4-.8-.8 0-1.5.1-2.3.3-.8.2-1.5.7-2.2 1.3-.7.6-1.2 1.3-1.6 2.3-.4 1-.7 2.2-.8 3.6h13zM966.1 69.8c0-.3 0-.8-.1-1.4-.1-.6-.3-1.1-.6-1.8-.2-.6-.7-1.2-1.4-1.6-.7-.4-1.6-.6-2.7-.6-1.5 0-2.7.4-3.5 1.2-.9.8-1.5 1.7-1.9 2.8-.4 1.1-.6 2.2-.7 3.2-.1 1.1-.2 1.8-.1 2.4 0 1.3.1 2.5.3 3.7.2 1.2.5 2.3.9 3.3.8 2 2.4 3 4.8 3.1 1.9 0 3.3-.7 4.1-1.9.8-1.1 1.2-2.3 1.2-3.6h4.6c-.2 2.5-1.1 4.6-2.7 6.3-1.7 1.8-4.1 2.7-7.1 2.7-.9 0-2.1-.2-3.6-.6-.7-.2-1.4-.6-2.2-1-.8-.4-1.5-1-2.2-1.7-.7-.9-1.4-2.1-2-3.6-.6-1.5-.9-3.5-.9-6.1 0-2.6.4-4.8 1.1-6.6.7-1.7 1.6-3.1 2.7-4.2 1.1-1 2.3-1.8 3.6-2.2 1.3-.4 2.5-.6 3.7-.6h1.6c.6.1 1.3.2 1.9.4.7.2 1.4.5 2.1 1 .7.4 1.3 1 1.8 1.7.9 1.1 1.4 2.1 1.7 3.1.2 1 .3 1.8.3 2.6h-4.7zM973.6 61.7h4.3v-5.2l4.5-1.5v6.8h5.4v3.4h-5.4v15.1c0 .3 0 .6.1 1 0 .4.1.7.4 1.1.2.4.5.6 1 .8.4.3 1 .4 1.8.4 1 0 1.7-.1 2.2-.2V87c-.9.2-2.1.3-3.8.3-2.1 0-3.6-.4-4.6-1.2-1-.8-1.5-2.2-1.5-4.2V65.1h-4.3v-3.4zM993.5 50.9h5.5V56h-5.5v-5.1m.5 10.9h4.6v25.1H994V61.8zM1006.1 74.7c0-1.6.2-3.2.6-4.8.4-1.6 1.1-3 2-4.4 1-1.3 2.2-2.4 3.8-3.2 1.6-.8 3.6-1.2 5.9-1.2 2.4 0 4.5.4 6.1 1.3 1.5.9 2.7 2 3.6 3.3.9 1.3 1.5 2.8 1.8 4.3.2.8.3 1.5.4 2.2v2.2c0 3.7-1 6.9-3 9.5-2 2.6-5.1 4-9.3 4-4-.1-7-1.4-9-3.9-1.9-2.5-2.9-5.6-2.9-9.3m4.7-.3c0 2.7.6 5 1.8 6.9 1.2 2 3 3 5.6 3.1.9 0 1.8-.2 2.7-.5.8-.3 1.6-.9 2.3-1.7.7-.8 1.3-1.9 1.8-3.2.4-1.3.6-2.9.6-4.7-.1-6.4-2.5-9.6-7.1-9.6-.7 0-1.5.1-2.4.3-.8.3-1.7.8-2.5 1.6-.8.7-1.4 1.7-1.9 3-.6 1.1-.9 2.8-.9 4.8zM1038.6 64.7l-.1-2.9h4.6v4.1c.2-.3.4-.8.7-1.2.3-.5.8-1 1.3-1.5.6-.5 1.4-1 2.3-1.3.9-.3 2-.5 3.4-.5.6 0 1.4.1 2.4.2.9.2 1.9.5 2.9 1.1 1 .6 1.8 1.4 2.5 2.5.6 1.2 1 2.7 1 4.7V87h-4.6V71c0-.9-.1-1.7-.2-2.4-.2-.7-.5-1.3-1.1-1.9-1.2-1.1-2.6-1.7-4.3-1.7-1.7 0-3.1.6-4.3 1.8-1.3 1.2-2 3.1-2 5.7V87h-4.6V64.7zM479.1 100.8h5.2l14.1 36.1h-5.3l-3.8-9.4h-16.2l-3.8 9.4h-5l14.8-36.1m-4.4 22.7H488l-6.5-17.8-6.8 17.8zM508.7 138.8c.1.7.2 1.4.4 1.9.2.6.5 1.1.9 1.6.8.9 2.3 1.4 4.4 1.5 1.6 0 2.8-.3 3.7-.9.9-.6 1.5-1.4 1.9-2.4.4-1.1.6-2.3.7-3.7.1-1.4.1-2.9.1-4.6-.5.9-1.1 1.7-1.8 2.3-.7.6-1.5 1-2.3 1.3-1.7.4-3 .6-3.9.6-1.2 0-2.4-.2-3.8-.6-1.4-.4-2.6-1.2-3.7-2.5-1-1.3-1.7-2.8-2.1-4.4-.4-1.6-.6-3.2-.6-4.8 0-4.3 1.1-7.4 3.2-9.5 2-2.1 4.6-3.1 7.6-3.1 1.3 0 2.3.1 3.2.4.9.3 1.6.6 2.1 1 .6.4 1.1.8 1.5 1.2l.9 1.2v-3.4h4.4l-.1 4.5v15.7c0 2.9-.1 5.2-.2 6.7-.2 1.6-.5 2.8-1 3.7-1.1 1.9-2.6 3.2-4.6 3.7-1.9.6-3.8.8-5.6.8-2.4 0-4.3-.3-5.6-.8-1.4-.5-2.4-1.2-3-2-.6-.8-1-1.7-1.2-2.7-.2-.9-.3-1.8-.4-2.7h4.9m5.3-5.8c1.4 0 2.5-.2 3.3-.7.8-.5 1.5-1.1 2-1.8.5-.6.9-1.4 1.2-2.5.3-1 .4-2.6.4-4.8 0-1.6-.2-2.9-.4-3.9-.3-1-.8-1.8-1.4-2.4-1.3-1.4-3-2.2-5.2-2.2-1.4 0-2.5.3-3.4 1-.9.7-1.6 1.5-2 2.4-.4 1-.7 2-.9 3-.2 1-.2 2-.2 2.8 0 1 .1 1.9.3 2.9.2 1.1.5 2.1 1 3 .5.9 1.2 1.6 2 2.2.8.7 1.9 1 3.3 1zM537.6 125.2c-.1 2.6.5 4.8 1.7 6.5 1.1 1.7 2.9 2.6 5.3 2.6 1.5 0 2.8-.4 3.9-1.3 1-.8 1.6-2.2 1.8-4h4.6c0 .6-.2 1.4-.4 2.3-.3 1-.8 2-1.7 3-.2.3-.6.6-1 1-.5.4-1 .7-1.7 1.1-.7.4-1.5.6-2.4.8-.9.3-2 .4-3.3.4-7.6-.2-11.3-4.5-11.3-12.9 0-2.5.3-4.8 1-6.8s2-3.7 3.8-5.1c1.2-.8 2.4-1.3 3.7-1.6 1.3-.2 2.2-.3 3-.3 2.7 0 4.8.6 6.3 1.6s2.5 2.3 3.1 3.9c.6 1.5 1 3.1 1.1 4.6.1 1.6.1 2.9 0 4h-17.5m12.9-3v-1.1c0-.4 0-.8-.1-1.2-.1-.9-.4-1.7-.8-2.5s-1-1.5-1.8-2.1c-.9-.5-2-.8-3.4-.8-.8 0-1.5.1-2.3.3-.8.2-1.5.7-2.2 1.3-.7.6-1.2 1.3-1.6 2.3-.4 1-.7 2.2-.8 3.7h13zM562.9 114.7l-.1-2.9h4.6v4.1c.2-.3.4-.8.7-1.2.3-.5.8-1 1.3-1.5.6-.5 1.4-1 2.3-1.3.9-.3 2-.5 3.4-.5.6 0 1.4.1 2.4.2.9.2 1.9.5 2.9 1.1 1 .6 1.8 1.4 2.5 2.5.6 1.2 1 2.7 1 4.7V137h-4.6v-16c0-.9-.1-1.7-.2-2.4-.2-.7-.5-1.3-1.1-1.9-1.2-1.1-2.6-1.7-4.3-1.7-1.7 0-3.1.6-4.3 1.8-1.3 1.2-2 3.1-2 5.7V137h-4.6v-22.3zM607 119.8c0-.3 0-.8-.1-1.4-.1-.6-.3-1.1-.6-1.8-.2-.6-.7-1.2-1.4-1.6-.7-.4-1.6-.6-2.7-.6-1.5 0-2.7.4-3.5 1.2-.9.8-1.5 1.7-1.9 2.8-.4 1.1-.6 2.2-.7 3.2-.1 1.1-.2 1.8-.1 2.4 0 1.3.1 2.5.3 3.7.2 1.2.5 2.3.9 3.3.8 2 2.4 3 4.8 3.1 1.9 0 3.3-.7 4.1-1.9.8-1.1 1.2-2.3 1.2-3.6h4.6c-.2 2.5-1.1 4.6-2.7 6.3-1.7 1.8-4.1 2.7-7.1 2.7-.9 0-2.1-.2-3.6-.6-.7-.2-1.4-.6-2.2-1-.8-.4-1.5-1-2.2-1.7-.7-.9-1.4-2.1-2-3.6-.6-1.5-.9-3.5-.9-6.1 0-2.6.4-4.8 1.1-6.6.7-1.7 1.6-3.1 2.7-4.2 1.1-1 2.3-1.8 3.6-2.2 1.3-.4 2.5-.6 3.7-.6h1.6c.6.1 1.3.2 1.9.4.7.2 1.4.5 2.1 1 .7.4 1.3 1 1.8 1.7.9 1.1 1.4 2.1 1.7 3.1.2 1 .3 1.8.3 2.6H607zM629.1 137.1l-3.4 9.3H621l3.8-9.6-10.3-25h5.2l7.6 19.8 7.7-19.8h5z"/>
                </svg>
              </span>
            </a>
            <button class="usa-menu-btn usa-button l-header__menu-button">Menu</button>
          </div>
          <div class="l-header__search">
            <form class="usa-search usa-search--small usa-search--epa" method="get" action="https://search.epa.gov/epasearch">
              <div role="search">
                <label class="usa-sr-only" for="search-box">Search</label>
                <input class="usa-input" id="search-box" type="search" name="querytext" placeholder="Search EPA.gov">
                <!-- button class="usa-button" type="submit" --> <!-- type="submit" - removed for now to allow other unrendered buttons to render when triggered in RShiny app -->
                <!-- see: https://github.com/rstudio/shiny/issues/2922 -->
                <button class="usa-button usa-search__submit" style="height:2rem;margin:0;padding:0;padding-left:1rem;padding-right:1rem;border-top-left-radius: 0;border-bottom-left-radius: 0;">
                  <span class="usa-sr-only">Search</span>
                </button>
                <input type="hidden" name="areaname" value="">
                <input type="hidden" name="areacontacts" value="">
                <input type="hidden" name="areasearchurl" value="">
                <input type="hidden" name="typeofsearch" value="epa">
                <input type="hidden" name="result_template" value="">
              </div>
            </form>
          </div>
        </div>
      </div>
      <div class="l-header__nav">
        <nav class="usa-nav usa-nav--epa" role="navigation" aria-label="EPA header navigation">
          <div class="usa-nav__inner">
            <button class="usa-nav__close" aria-label="Close">
              <svg class="icon icon--nav-close" aria-hidden="true" role="img">
                <title>Primary navigation</title>
                <use xlink:href="https://www.epa.gov/themes/epa_theme/images/sprite.artifact.svg#close"></use>
              </svg> </button>
            <div class="usa-nav__menu">
               <ul class="menu menu--main">
                <li class="menu__item"><a href="https://www.epa.gov/environmental-topics" class="menu__link">Environmental Topics</a></li>
                <li class="menu__item"><a href="https://www.epa.gov/laws-regulations" class="menu__link" >Laws &amp; Regulations</a></li>
                <li class="menu__item"><a href="https://www.epa.gov/report-violation" class="menu__link" >Report a Violation</a></li>
                <li class="menu__item"><a href="https://www.epa.gov/aboutepa" class="menu__link" >About EPA</a></li>
              </ul>
            </div>
          </div>
        </nav>
      </div>
    </header>
    <main id="main" class="main" role="main" tabindex="-1">'
		),
	
	# Individual Page Header
	HTML(
	  '<div class="l-page  has-footer">
      <div class="l-constrain">
        <div class="l-page__header">
          <div class="l-page__header-first">
            <div class="web-area-title"></div>
          </div>
          <div class="l-page__header-last">
            <a href="https://www.epa.gov/national-aquatic-resource-surveys/forms/contact-us-about-national-aquatic-resource-surveys" class="header-link">Contact Us</a>
          </div>
        </div>
        <article class="article">'
	),
	####Instructions####
  # Application title 
  titlePanel(span("Survey Design Tool (v. 1.1.0)", 
                  style = "font-weight: bold; font-size: 28px")),
  navbarPage(id = "inTabset", 
             title = "",
             selected='instructions', position='static-top',
             inverse = TRUE,
             # Panel with instructions for using this tool
             tabPanel(title=span(strong("Step 1: Instructions for Use"), 
                                 style = "font-weight: bold; font-size: 20px"), value='instructions',
                      bsCollapse(id = "instructions",   
                                 bsCollapsePanel(title = h1(strong("Overview")), value="Overview",
                                      p("This R Shiny app allows for the calculation of spatially balanced survey designs of point, linear, or areal resources using the Generalized Random-Tessellation Stratified (GRTS) algorithm,", tags$a(href= "https://cfpub.epa.gov/ncer_abstracts/index.cfm/fuseaction/display.files/fileID/13339", "Stevens and Olsen (2004).", target="blank"), 
                                        "The Survey Design Tool utilizes functions found within the R package", tags$a(href="https://cran.r-project.org/package=spsurvey",
                                                                                                                                  "spsurvey: Spatial Sampling Design and Analysis", target="blank"), "and presents an easy-to-use user interface for many sampling design features including stratification, unequal and proportional inclusion probabilities, replacement (oversample) sites, and legacy (historical) sites. 
                                      The output of the Survey Design Tool contains sites designed and balanced by user specified inputs and allows the user to export sampling locations as a point shapefile or a flat file. The output also provides design weights which can be used in categorical and continuous variable analyses (i.e., population estimates). 
                                      The tool also gives the user the ability to adjust initial survey design weights when implementation results in the use of replacement sites or when it is desired to have final weights sum to a known frame size."), 
                                      
                                      p("This app does not include all possible design options and tools found in the spsurvey package. Please review the package", tags$a(href= "https://www.rdocumentation.org/packages/spsurvey", "Documentation", target="blank"), "and", tags$a(href= "https://github.com/USEPA/spsurvey", "Vignettes", target="blank"), "for more options and details.  
                                      For further survey discussion and use cases, visit the website for", tags$a(href="https://www.epa.gov/national-aquatic-resource-surveys", "EPAs National Aquatic Resource Surveys (NARS)", target="blank"), 
                                      "which are designed to assess the quality of the nation's coastal waters, lakes and reservoirs, rivers and streams, and wetlands using GRTS survey designs. We encourage users to consult with a statistician about your design to prevent design issues and errors."),
                                      p("For Survey Design Tool questions, bugs, feedback, or tool modification suggestions, please contact Garrett Stillings at", tags$a(href="mailto:stillings.garrett@epa.gov", "stillings.garrett@epa.gov.", target="blank"),
                                        "The application code and test datasets are offered at the", tags$a(href="https://github.com/USEPA/OW_Survey_Design_Tool", "Survey Design Tool GitHub page.", target="blank")),
                                      h4(strong("Vignette")),
                                      h4(strong(tags$ul(
                                        tags$li(tags$a(href="https://cran.r-project.org/web/packages/spsurvey/vignettes/sampling.html",
                                                       "Spatially Balanced Sampling", target="blank")))))),
                                 bsCollapsePanel(title = h3(strong("Prepare Survey Design Tab")), value="prepare",
                                                 tags$ol(
                                                   h4(strong("Requirements")),
                                                   tags$ul(
                                                     tags$li("The Survey Design Tool located on the EPA shiny server is only capable of running designs which use less than 2GB of memory. Please visit the Survey Design Tool GitHub site for the source code to run the app locally for much improved processing."),
                                                     tags$li("The coordinate reference system (CRS) for the sample frame should use an area-preserving projection such as Albers or UTM so that spatial distances are equivalent for all directions. Geographic CRS are not accepted."),
                                                     tags$li("All design attribute variables, such as the Strata and Categories, must be contained in the user's sample frame file. You may run the design without these inputs as an unstratified equal probability design."),
                                                     tags$li("When constructing your design, the user must decide how they want their survey to be designed and which random selection to use:"),
                                                     tags$ul(
                                                       tags$li(strong("Equal Probability Sampling")," - equal inclusion probability. Selection where all units of the population have the same probability of being selected."),
                                                       tags$li(strong("Stratified Sampling")," - Selection where the sample frame is divided into non-overlapping strata which independent random samples are calculated."),
                                                       tags$li(strong("Unequal Probability Sampling")," - unequal inclusion probability. Selection where the chance of being included is calculated relative to the distribution of a categorical variable across the population which does not guarantee a user specified sample size. This type of sampling can give smaller populations a greater chance of being selected."), 
                                                       tags$li(strong("Proportional Probability Sampling")," - proportional inclusion probability. Selection where the chance of being included is proportional to the values of a positive auxiliary variable. For example, if you have many strata in your design, this will ensure each stratum has a sample."))),
                                                   br(),
                                                   bsCollapsePanel(title = h4(strong("Designing the Survey")), value="design",
                                                                   tags$li("Select the Sample Frame. Sample frames must be an ESRI shapefile. The user must select all parts of the shapefiles which include .shp, .dbf, .shx. and .prj files (Tip: Hold down ctrl and select each file). The coordinate system for the sample frame must be one where distance for the coordinates is meaningful. The attributes in the file will populate as possible inputs for the design. Maximum size is currently 10GB."),
                                                                   tags$li("Choose your desired Design Type:",
                                                                           tags$ul(
                                                                             tags$li(strong("GRTS")," - Generalized Random Tessellation Stratified. For survey designs desiring spatially balanced samples."),
                                                                             tags$li(strong("IRS")," - Independent Random Sample. For survey designs desiring non-spatially balanced samples."))),
                                                                   tags$li("Select Strata attribute. If your design is stratified, select the attribute which indicates the desired Strata. If Stratum equals 'None', the design is unstratified. The default is 'None'. Example Strata could be Stream Type (Perennial and Intermittent) or Size (Large and Small)."),
                                                                   tags$li("Select Category attribute. For an unequal inclusion probability design, select the attribute which indicates the categorical variable which the selection will be based on. Often, the output Category sample sizes will be close, but not exact to the user's sample sizes allocated for each Category. This is because the Category-level sample sizes are random variables. The default is 'None'. An example Category could be stream order or elevation (high/low)."),
                                                                   br(),
                                                                   h4(strong(em("Optional: Additional Design Attributes"))),
                                                                   tags$ul(
                                                                   tags$li("Additional design attributes such as Auxiliary Variables, Reproducible Seed, DesignID, Minimum Distance, Maximum Attempts, Point Density, and Nearest Neighbor Replacement Sites are also available. Descriptions of these inputs can be found in the grts section on the spsurvey manual as well as the helper buttons next to the inputs."),
                                                                   br(),
                                                                   h4(strong(em("Legacy Sampling"))),
                                                                   tags$li("Legacy sites are sites that have been selected in a previous probability sample and are to be automatically included in the current probability sample."),
                                                                   tags$li("Upload a POINT sample frame which contains the Legacy sites you would like included in the design. All sites in the legacy file will be considered legacy sites."),
                                                                   tags$li("If your Legacy sample frame has different Strata, Category or Auxiliary variable names than your design sample frame, select the corresponding attribute(s) from the legacy sample frame. These inputs will not appear if the names match your design sample frame."),
                                                                   tags$li("The number of legacy sites must be greater than number of base sites in at least one stratum.")
                                                   ))),
                                                 tags$ol(
                                                   bsCollapsePanel(title = h4(strong("Determine Survey Sample Sizes")), value="samplesize",
                                                                   p("Setting an appropriate sample size and considering how they should be allocated across a sample frame is a fundamental step in designing a successful survey. Many surveys, especially those used for environmental monitoring, are limited by budgetary and logistical constraints. The designer must determine a sample size which can overcome these constraints while ensuring the survey estimates the parameter(s) of interest with a low margin of error.
                                                                      The designer can consider a few elements when determining a survey sample size:"),
                                      tags$ul(
                                        tags$li("Select a spatially balanced survey using the spatial balance metrics provided. Typically, estimates from spatially balanced surveys are more precise (vary less) than estimates from non-spatially balanced surveys."),
                                        tags$li("Consider what will be measured in the survey. If you anticipate the parameter of interest to result in low variation across the survey, a smaller sample size can yield a low margin of error estimate. Conversely, if you anticipate the parameter of interest to result in high variation, you should consider increasing the sample size to account for a higher margin of error."),
                                        tags$li("Allocate additional sampling time to survey extra sites if needed. When designing the survey, be sure to generate replacement sites to use for oversampling.")),
                                      br(),
                                      p("To aid the user, in the 'Survey Design tab' simulated population estimates using the local neighborhood variance estimator (uses a site's nearest neighbors to estimate variance, tending to result in smaller 
                                         variance values) and will be calculated using the users defined sample sizes. This can give the user insight on the survey estimates potential margin of error if the sample size(s) chosen is used."),
                                      tags$li("For unstratified equal probability designs, set the desired Base site sample size."),
                                      tags$li("If you supplied a Stratum attribute, a tab is populated for each Stratum of the design."),
                                      tags$li("Set the sample size of Base sites you desire for each stratum."),
                                      tags$li("If you supplied a Category attribute, these categories will automatically populate. Choose the sample sizes for each. NOTICE: the sum of the sample sizes must equal the base site sample size."),
                                      tags$li("Choose the sample size of the Replacement Sites you desire, if any. Replacement sites are an additional set of sites that can be used to replace the main sample list sites when they are found to be non-target or inaccessible. When replacing a site with a replacement, the user must FOLLOW THE ORDER of the design output and select a replacement site of the same Stratum, if used. If replacement sites are used improperly it may result in spatial imbalance. 
                                              The tool attempts to distribute the replacement sites proportionately among sample sizes for the Categories. If the replacement proportion for one or more Categories is not a whole number, the proportion is rounded to the next higher integer. Choose a reasonable replacment sample size as requesting too many unused sites can impact the spatial balance of your design."),
                                      tags$li("Once your design has been prepared, click the 'Calculate Survey Design' button to be transported to the Survey Design Results tab.")
                                                   ))),
                                 bsCollapsePanel(title = h3(strong("Survey Design Results Tab")), value="survey",
                                                 tags$ol(
                                                   h4(strong("Survey Design")),
                                                   tags$li("The process of calculating your Survey Design can take a while. The spinner will stop when your Survey Design is complete. If you have errors in your Design inputs, a message with the error will be displayed under 'Design Errors'. "),
                                                   tags$li("A table of your Survey Design will appear if successful. A table will be displayed with totals of your sample sizes allocated across strata and categories, if used."),
                                                   tags$li("The Population Estimate Simulation module can give the user insight on the survey estimates potential margin of error if the input sample size(s) are used. Condition classes assigned to each site are randomly selected using user specified probability weights. Typically, margin of error will decrease if the condition class distribution is unequally distributed.
                                                            The user can choose the number of condition classes used, modify the probability of being selected, and refresh the simulation to view different condition scenarios. The user can adjust the sample size and refresh the design to determine an appropriate margin of error for the survey."),
                                               tags$li("Choose a Spatial Balance Metric. All spatial balance metrics provided have a lower bound of zero, which indicates perfect spatial balance. As the metric value increases, the spatial balance decreases. This is useful in comparing survey designs."),
                                               tags$li("Click the 'Download Survey Site Shapefile' button to download a zip file which contains a POINT shapefile of your designs survey sample sites."),
                                               tags$li("To download the Probability Survey Site Results table, use the buttons to choose how you would like it to be saved. Please note the Lat/Longs are transformed to WGS84 coordinate system. The xcoord and ycoord are Conus Albers (a projected CRS) coordinates which is an area-preserving projection. These coordinates can be used for the local neighborhood variance estimator when calculating population estimates."),
                                               tags$li("To download the Design Setup Attributes table, use the buttons to choose how you would like it to be saved. We strongly encourage users to download and retain this information for future reference. The table includes the spurvey function call for your design, the random seed used, and the spsurvey and R versions."),
                                               br(),
                                               h4(strong("Survey Map")),
                                               tags$li("The Survey Map tab provides an interactive and static map of the sample frame and the survey sample sites.")
                                                 )),
                                 bsCollapsePanel(title = h3(strong("Adjust Survey Weights Tab")), value="adjust",
                                                 p("Adjusting initial survey design weights is necessary when implementation results in the use of replacement sites or when it is desired to have final weights sum to known frame size of the desired population. This includes samples that are smaller or larger than planned, instances where an oversample is used, or samples impacted by frame error or nonresponse error. Adjusted weights are equal to initial weight * framesize/sum(initial weights). The adjustment is done separately for each 
                                                    Category specified in Weighting Category input. The tool allows the user to manually enter a desired population Frame Size or an automated calculation of the frame size by totaling the initial weights and adjusting it by the users site Evaluation Status inputs. By using the automated method, the output will render two adjusted weights:"),
                                      tags$ul(
                                        tags$li(strong("WGT_TP_EXTENT")," - Weights based on the evaluation of all target and non-target probability sites. These weights are only used to estimate extent for target and non-target populations."),
                                        tags$li(strong("WGT_TP_CORE")," - Weights based on the evaluation of the target population based on sampled probability sites. These weights can be used to estimate condition for the 'target population'. Current NARS population estimates only use WGT_TP_CORE for all estimates related to condition.")
                                      ),
                                      p(tags$a(href="https://rdrr.io/cran/spsurvey/man/adjwgt.html", "Weights Adjustment Example", target= "_blank")),
                                      tags$ol(
                                        h4(strong("Weight Adjustment File Setup Examples")),
                                        fixedRow(column(4,
                                                        tags$table(border = 5, 
                                                                   tags$thead(
                                                                     tags$tr(
                                                                       tags$th(colspan = 3, height = 10, width = 500,
                                                                               style="text-align: center", "Equal Probability Design")
                                                                     )
                                                                   ), 
                                                                   tags$tbody(
                                                                     tags$tr(
                                                                       tags$td(align = "center", strong("SiteID")),
                                                                       tags$td(align = "center", strong("Weight")),
                                                                       tags$td(align = "center", strong("Site Evaluation")),
                                                                     ),
                                                                     tags$tr(
                                                                       tags$td(align = "center", "Site_01"),
                                                                       tags$td(align = "center", "2"),
                                                                       tags$td(align = "center", "Target-Sampled"),
                                                                     ),
                                                                     tags$tr(
                                                                       tags$td(align = "center", "Site_02"),
                                                                       tags$td(align = "center", "2"),
                                                                       tags$td(align = "center", "Non-Target"),
                                                                     ), 
                                                                     tags$tr(
                                                                       tags$td(align = "center", "Site_02_Replace"),
                                                                       tags$td(align = "center", "2"),
                                                                       tags$td(align = "center", "Target-Replacement-Sampled"),
                                                                     ), 
                                                                     tags$tr(
                                                                       tags$td(align = "center", "Site_03"),
                                                                       tags$td(align = "center", "2"),
                                                                       tags$td(align = "center", "Target-Access_Denied"),
                                                                     ), 
                                                                     tags$tr(
                                                                       tags$td(align = "center", "Site_03_Replace"),
                                                                       tags$td(align = "center", "2"),
                                                                       tags$td(align = "center", "Target-Replacement-Sampled"),
                                                                     ), 
                                                                     tags$tr(
                                                                       tags$td(align = "center", "Site_04"),
                                                                       tags$td(align = "center", "2"),
                                                                       tags$td(align = "center", "Target-Sampled-Additional"),
                                                                     )))),
                                                 column(5, offset = 1,
                                                        tags$table(border = 5, 
                                                                   tags$thead(
                                                                     tags$tr(
                                                                       tags$th(colspan = 4, height = 10, width = 500,
                                                                               style="text-align: center", "Unequal Probability Design")
                                                                     )
                                                                   ), 
                                                                   tags$tbody(
                                                                     tags$tr(
                                                                       tags$td(align = "center", strong("SiteID")),
                                                                       tags$td(align = "center", strong("Category")),
                                                                       tags$td(align = "center", strong("Weight")),
                                                                       tags$td(align = "center", strong("Site Evaluation")),
                                                                     ),
                                                                     tags$tr(
                                                                       tags$td(align = "center", "Site_01"),
                                                                       tags$td(align = "center", "1st Order"),
                                                                       tags$td(align = "center", "2"),
                                                                       tags$td(align = "center", "Target-Sampled"),
                                                                     ),
                                                                     tags$tr(
                                                                       tags$td(align = "center", "Site_02"),
                                                                       tags$td(align = "center", "2nd Order"),
                                                                       tags$td(align = "center", "3"),
                                                                       tags$td(align = "center", "Non-Target"),
                                                                     ), 
                                                                     tags$tr(
                                                                       tags$td(align = "center", "Site_02_Replace"),
                                                                       tags$td(align = "center", "2nd Order"),
                                                                       tags$td(align = "center", "3"),
                                                                       tags$td(align = "center", "Target-Replacement-Sampled"),
                                                                     ), 
                                                                     tags$tr(
                                                                       tags$td(align = "center", "Site_03"),
                                                                       tags$td(align = "center", "3rd Order"),
                                                                       tags$td(align = "center", "4"),
                                                                       tags$td(align = "center", "Target-Access_Denied"),
                                                                     ), 
                                                                     tags$tr(
                                                                       tags$td(align = "center", "Site_03_Replace"),
                                                                       tags$td(align = "center", "3rd Order"),
                                                                       tags$td(align = "center", "4"),
                                                                       tags$td(align = "center", "Target-Replacement-Sampled"),
                                                                     ), 
                                                                     tags$tr(
                                                                       tags$td(align = "center", "Site_04"),
                                                                       tags$td(align = "center", "1st Order"),
                                                                       tags$td(align = "center", "2"),
                                                                       tags$td(align = "center", "Target-Sampled-Additional"),
                                                                     ))))),
                                        br(),
                                        h4(strong("Weight Adjustment Inputs")),
                                        tags$li("Upload the file which contains the required weight adjustment inputs. See below for the descriptions of each input."),
                                        tags$li("Select the column which has the initial unadjusted weights for each site. The sum of these weights is how the tool calculates the frame size. You also have the option to input the frame size manually."),
                                        tags$li("Select the Weighting Category column used in an unequal survey design. Use 'None' if the design is an equal probability design and all sites are in the same category."),
                                        tags$li("Select the column which contains the Site Evaluation Attributes which categorically evaluate which sites are target and non-target sites and which have been sampled, including Replacement sites both as replacement and additional (e.g., Target-Sampled, Non-Target, Target-Landowner Denial, Target-Sampled-Additional). 
                                              These inputs aid in the automated calculation of the Frame Size used for both the TP_EXTENT and TP_CORE Weights. To manually enter the Frame Size by Category, ignore the 3 inputs below and click the 'Adjust the Frame Size Manually' radio button."),
                                        tags$ul(
                                          tags$li("Select the attribute(s) which indicate if the site was a Target site (Base and Replacement sites) and has been sampled. If available, this input should include additional Replacement sites which were added to the design and not used as replacement (e.g., Target-Sampled, Target-Sampled-Additional)."),
                                          tags$li("Select the attribute(s) which indicate if the site was a Target Replacement site added to the survey as an additional site and not as a replacement (e.g., Target-Sampled-Additional)."),
                                          tags$li("Select the attribute(s) which indicate if the site was a Non-Target site and was not sampled (e.g., Non-Target).")
                                        ),
                                        tags$li("Press the radio button if you wish to input the frame size manually. Based on if you entered a weighting category, the number of frame sizes needed will be generated. The adjusted weights will now be based on this Frame Size."),
                                        tags$li("Press the 'Calculate Adjusted Survey Weights' button for the adjusted weight output.")
                                      ))),
                      hr(),
                      h3(strong('Citation')),
                      tags$head(
                        tags$style(
                          HTML("#citation {font-size: 14px;}"))),
                      p("If you have used the Survey Design Tool to generate a survey used in publication or reporting, please reference the tool URL (https://owshiny.epa.gov/survey-design-tool/) and cite the spsurvey package."),
                      verbatimTextOutput("citation"),
                      br(),hr(),
                      h3(strong('Disclaimer')),
                      p('The United States Environmental Protection Agency (EPA) Survey Design tool and code is provided on an "as is" basis and the user assumes responsibility for its use.  
                                      EPA has relinquished control of the information and no longer has responsibility to protect the integrity, confidentiality, or availability of the information.  
                                      Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their 
                                      endorsement, recommendation or favoring by EPA.  The EPA seal and logo shall not be used in any manner to imply endorsement of any commercial product or activity 
                                      by EPA or the United States Government.'),
                      br(), hr()),
             
             ####Prepare Design####
             # Panel to import and prepare survey design
             tabPanel(title=span(strong('Step 2: Prepare Survey Design'), 
                                 style = "font-weight: bold; font-size: 20px"), value='Step 2: Prepare Survey Design',
                      sidebarPanel(
                        
                        h4(strong(HTML("<center>Select the Survey Sample Frame<center/>"))),
                        #h5(strong(HTML("<center>Use Your Own Sample Frame<center>"))),
                        
                        # Input: Select sample frame files 
                        fileInput(
                          inputId = "filemap",
                          label = HTML("<b>Choose all files of the Sample Frame </br>Required: (.shp, .dbf, .prj, .shx)</b>"),
                          multiple = TRUE,
                          accept = c(".gdb", ".shp", ".prj", ".shx", ".dbf", ".sbn", ".sbx", ".cpg", ".gpkg"), 
                          width = "600px") %>%
                          #User Sample Frame helper
                          helper(icon = "circle-question",type = "inline",
                                 title = "Survey Sample Frame",
                                 content = c("A Survey Sample Frame is an ESRI shapefile which contains geographic features represented by points, lines or polygons which is used in the selection of the sample. Maximum sample frame size is currently 10GB.",
                                             "The coordinate reference system (CRS) for the sample frame should be an area-preserving projection. If a geographic CRS is used, the user may choose to transform the CRS to NAD83 / Conus Albers (a projected CRS) by checking the box below.",
                                             "<b>Required Files:</b>",
                                             "<b>Shapefiles (.shp, .dbf, .prj, .shx)</b>"),
                                 
                                 size = "s", easyClose = TRUE, fade = TRUE),
                        checkboxInput(inputId = "NAD83", 
                                      label= strong("Transform CRS to NAD83 / Conus Albers"), 
                                      value = FALSE, 
                                      width = NULL),
                        hr(),
                        h4(strong(HTML("<center>Design Attributes<center/>"))),
                        fixedRow(
                          column(6,
                        #Design Type Input
                        radioButtons(inputId="designtype", 
                                     label=strong("Choose Design Type"), 
                                     choices=c("GRTS","IRS"),
                                     inline=TRUE) %>%
                          #Design Type helper
                          helper(icon = "circle-question",type = "inline",
                                 title = "Design Type",
                                 content = c("<b>GRTS:</b> Generalized Random Tessellation Stratified-for spatially balanced samples",
                                             "<b>IRS:</b> Independent Random Sample- for non-spatially balanced samples"),
                                 size = "s", easyClose = TRUE, fade = TRUE))),
                        
                        #Stratum Input
                        selectInput(inputId = "stratum",
                                    label = strong("Select Attribute Which Contains Strata"),
                                    choices = "",
                                    selected = NULL,
                                    multiple = FALSE, 
                                    width = "300px")  %>%
                          #Strata helper
                          helper(icon = "circle-question",type = "inline",
                                 title = "Stratum",
                                 content = c("A subpopulation within your sample frame to independently sample. Use the default <b>None</b> if your design is unstratified.",
                                             "<b>Examples:</b> Stream Type (Perennial and Intermittent), Size (Large and Small"),
                                 size = "s", easyClose = TRUE, fade = TRUE),
                        
                        #Category Input
                        selectInput(inputId = "caty",
                                    label = strong("Select Attribute Which Contains Categories"),
                                    choices = "",
                                    selected = NULL,
                                    multiple = FALSE, 
                                    width = "300px") %>%
                          #Category helper
                          helper(icon = "circle-question",type = "inline",
                                 title = "Multi-density Category",
                                 content = c("Variables found within a stratum used to define design weights for unequal probability selections. Use the default <b>None</b> if your design is an equal probability design.",
                                             "<b>Examples:</b> Stream Order, Lake Area, Basin, Ecoregion"),
                                 size = "s", easyClose = TRUE, fade = TRUE),
                        checkboxInput(inputId = "addoptions", 
                                      label=strong("Optional Design Attributes"), 
                                      value = FALSE),
                        uiOutput('addoptions'),
                        conditionalPanel(condition = "input.addoptions == 1",
                        hr(),
                        h4(strong(HTML("<center>Legacy Site Sampling<center/>"))),
                        ####Legacy Sampling####
                        uiOutput("legacyfile"),
                        
                        
                        uiOutput("legacyvar"),
                        
                        
                        uiOutput('legacystrat'),
                        
                        uiOutput('legacycat'),
                        
                        uiOutput('legacyaux')),
                        
                        hr(),
                        
                        # Press button for analysis 
                        actionButton("goButton", strong("Calculate Survey Design"), icon=icon("circle-play"), 
                                     style="color: #fff; background-color: #337ab7; border-color: #2e6da4; font-size:130%")),#sidebarPanel
                      mainPanel(
                        uiOutput('mytabs'),
                        conditionalPanel(condition = "output.mytabs",
                                         hr(),
                                         fixedRow(
                                           column(4,
                                         checkboxInput(inputId = "addSF_SUM", 
                                                       label=span(strong("Sample Frame Summary"),
                                                                  style="font-weight: bold; font-size: 18px"), 
                                                       value = FALSE) %>%
                          #SF Summary helper
                          helper(icon = "circle-question",type = "inline",
                                 title = "Sample Frame Summary",
                                 content = c("Aids user in summarizing the sample frame based on the selected Strata and Categories. These proportions can assist in setting sample size(s)."),
                                 size = "s", easyClose = TRUE, fade = TRUE)))),
                          conditionalPanel(condition = "input.addSF_SUM",
                                           br(),
                                           fixedRow(
                                             h3(HTML("<center><b>Sample Frame Summary</b></center>")),
                                             column(4,
                                                    DT::dataTableOutput("SF_SUM") %>% withSpinner(color="#0275d8"))),
                                           br(),
                                           fixedRow(
                            conditionalPanel(condition = "output.LEGACY_SUM",
                                             h3(HTML("<center><b>Legacy Sample Frame Summary</b></center>"))),
                                             column(4,
                                                    DT::dataTableOutput("LEGACY_SUM") %>% withSpinner(color="#0275d8")))
                                           )
                      ) #mainPanel
             ), #tabPanel (Prepare and Run Survey Design)
             ####Design Results####
             tabPanel(title=span(strong("Step 3: Survey Design Results"), 
                                 style = "font-weight: bold; font-size: 20px"),
                      value="Step 3: Survey Design Results",
                conditionalPanel(condition = "input.goButton",
                                 tagList(span("Remove/Restore Sidebar", style = "font-weight: bold; font-size: 25px; font-style:italic;",
                                              actionLink("sidebar_button","", icon = icon("bars")))),
                      sidebarLayout(
                        div(class="sidebar", 
                        sidebarPanel(
                          conditionalPanel(condition = "output.error",
                                           h4(HTML("<center><b>Design Errors</b></center>"))),
                          tableOutput("error"),
                          conditionalPanel(condition = "output.table",
                                           hr(),                 
                                           h4(HTML("<center><b>Survey Site Summary</b></center>")),
                                           dataTableOutput("summary"), 
                                                  style = "overflow-x: scroll;"),
                          conditionalPanel(condition = "output.summary",
                                           br(), hr(),
                                           h4(HTML("<center><b>Population Estimate Simulation</b></center>")) %>%
                                             #Simulation helper
                                             helper(icon = "circle-question",type = "inline",
                                                    title = "Population Estimate Simulation",
                                                    content = c("This module assists the user in simulating total population proportion estimates of a population based on the sample size used in the survey design. Error bars displayed show the Margin of Error for a condition.
                                                            The condition classes are randomly assigned by user specified probability weights and can be refreshed with new probability weights to simulate the change in conditions. 
                                                            Adjust the sample size of the design to increase or decrease the Margin of Error estimate."),
                                                    size = "s", easyClose = TRUE, fade = TRUE),
                                           fixedRow(
                                             column(6, offset=3,
                                           radioButtons(inputId="connumber", 
                                                        label=strong("Choose Condition Class Size"), 
                                                        choices=c("2","3","4","5"), 
                                                        selected = "3",
                                                        inline=TRUE) %>%
                                             #Condition Class helper
                                             helper(icon = "circle-question",type = "inline",
                                                    title = "Conditional Class Size",
                                                    content = c("Choose the condition class size of your indicator. Assign random selection probabilities for each condition class to simulate potential population estimate results.
                                                            Indicators with larger condition class sizes often have lower margin of error estimates.",
                                                            "<b>If condition probabilities do not sum to 100%, weights will be normalized to sum to 100%.</b>"),
                                                    size = "s", easyClose = TRUE, fade = TRUE))),
                                           uiOutput('conditionprb'),
                                           radioButtons(inputId="conflim", 
                                                        label=strong("Choose Confidence Limit"), 
                                                        choices=c("90%","95%"), 
                                                        selected = "95%",
                                                        inline=TRUE)),
                          conditionalPanel(condition = "input.CON2",
                                           plotOutput("ssplot") %>% withSpinner(color="#0275d8"),
                                           br(),
                                           actionButton("ssbtn", strong("Refresh Simulation"), icon=icon("arrow-rotate-right"), 
                                                        style="color: #fff; background-color: #337ab7; border-color: #2e6da4")),
                          hr(),
                          conditionalPanel(condition = "output.ssplot",
                                           h4(HTML("<center><b>Design Spatial Balance</b></center>")) %>%
                                             #Spatial Balance helper
                                             helper(icon = "circle-question",type = "inline",
                                                    title = "Spatial Balance",
                                                    content = c("All spatial balance metrics have a lower bound of zero, which indicates perfect spatial balance. As the metric value increases, the spatial balance decreases."),
                                                    size = "s", easyClose = TRUE, fade = TRUE),
                                           tags$head(
                                             tags$style(
                                               HTML("#balance {font-size: 14px;}"))),
                                           verbatimTextOutput("balance", placeholder = TRUE) %>% withSpinner(color="#0275d8"),
                                           actionButton("balancebtn", strong("Calculate Spatial Balance"), icon=icon("circle-play"), 
                                                        style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
                                           br(), br(),
                                           radioButtons("balance", strong("Spatial Balance Metric:"),
                                                        selected = "pielou",
                                                        c("Pielou's Evenness Index" = "pielou",
                                                          "Simpsons Evenness Index" = "simpsons",
                                                          "Root-Mean-Squared Error" = "rmse",
                                                          "Mean-Squared Error" = "mse",
                                                          "Median-Absolute Error" = "mae",
                                                          "Mean-Absolute Error" = "medae",
                                                          "Chi-Squared Loss" = "chisq")) %>%
                                             #Spatial Balance metric helper
                                             helper(icon = "circle-question",type = "inline",
                                                    title = "Spatial Balance Metrics",
                                                    content = c("<b>Pielou's Evenness Index</b> This statistic can take on a value between zero and one.",
                                                                "<b>Simpsons Evenness Index</b> This statistic can take on a value between zero and logarithm of the sample size.",
                                                                "<b>Root-Mean-Squared Error</b> This statistic can take on a value between zero and infinity.",
                                                                "<b>Mean-Squared Error</b> This statistic can take on a value between zero and infinity.",
                                                                "<b>Median-Absolute Error</b> This statistic can take on a value between zero and infinity.",
                                                                "<b>Mean-Absolute Error</b> This statistic can take on a value between zero and infinity.",
                                                                "<b>Chi-Squared Loss</b> This statistic can take on a value between zero and infinity."),
                                                    size = "s", easyClose = TRUE, fade = TRUE)), width = 5
                        )),#sidebarPanel
                        mainPanel(
                          
                          tabsetPanel(
                            tabPanel(title=strong("Design"),
                                     mainPanel(
                                              br(),
                                              conditionalPanel(condition = "output.table",
                                                                 h3(HTML("<center><b>Probability Survey Site Results</b></center>"))),
                                       br(),
                                         
                                                uiOutput("shp_btn"),
                                       br(),
                                         dataTableOutput(outputId = "table"),
                                       style="width: 110%;",
                                       br(), 
                                              conditionalPanel(condition = "output.call",
                                       h3(HTML("<center><b>Design Setup Attributes</b></center>"))),
                                              DT::dataTableOutput("call"))),
                            
                            tabPanel(title=strong("Survey Map"),
                                     br(),
                                     conditionalPanel(condition = "output.ssplot",
                                                      h3(HTML("<center><b>Interactive and Static Maps</b></center>")),
                                                      fixedRow(
                                                        tags$head(tags$style(HTML("#maptype ~ .selectize-control.single .selectize-input {background-color: #FFD133;}"))),
                                                        selectInput(inputId = "maptype",
                                                                    label = strong("Select Type of Map"),
                                                                    choices = c("Interactive", "Static"),
                                                                    selected = NULL,
                                                                    multiple = FALSE, 
                                                                    width = "200px"), 
                                                        column(3, offset = 3,
                                                               selectInput(inputId = "color",
                                                                           label = HTML("<b>Select Color <br/> Attribute</b>"),
                                                                           choices = c("Site Use" = "siteuse", 
                                                                                       "Stratum" = "stratum", 
                                                                                       "Category" = "caty"),
                                                                           selected = "siteuse",
                                                                           multiple = FALSE, 
                                                                           width = "200px")),
                                                        column(3, offset = 1,
                                                               conditionalPanel(condition = "input.maptype == 'Static'",
                                                                                selectInput(inputId = "shape",
                                                                                            label = HTML("<b>Select Shape <br/> Attribute</b>"),
                                                                                            choices = c("Site Use" = "siteuse", 
                                                                                                        "Stratum" = "stratum", 
                                                                                                        "Category" = "caty"),
                                                                                            selected = "stratum",
                                                                                            multiple = FALSE, 
                                                                                            width = "200px")))),
                                                      conditionalPanel(condition = "input.maptype == 'Interactive'",
                                                                       leafletOutput("map", width="100%", height="70vh") %>% withSpinner(color="#0275d8")),
                                                      conditionalPanel(condition = "input.maptype == 'Static'",
                                                                       plotOutput("plot") %>% withSpinner(color="#0275d8"))) 
                            )#tabPanel(Survey Map)
                          )#tabsetPanel
                          , width = 7)#mainPanel
                        , position = c("left", "right"), fluid = TRUE)#sidebarLayout
                )#Condition panel
             ),#tabPanel(Survey Design)
             ####Adjust Weights####
             tabPanel(title=span(strong("Step 4: Adjust Survey Weights"), 
                                 style = "font-weight: bold; font-size: 20px"), value="Step 4: Adjust Survey Weights",
                      sidebarPanel(
                        h4(strong(HTML("<center>Select the Weight Adjustment File<center/>"))),
                        fileInput(
                          inputId = "adjdata",
                          label = strong("(Must be a .csv file)"),
                          accept = c(".csv")) %>%
                          #Weight file helper
                          helper(icon = "circle-question",type = "inline",
                                 title = "Weight Adjustment File",
                                 content = c("Choose the .csv file which contains all base sites which were given initial weights and replacement sites which were sampled. This should include all target sites sampled, replacement sites sampled (including additional sites used as oversamples), not evaluated and non-target sites which were sampled, but were given an initial weight.",
                                             "<b>See Instructions For Use tab for examples on how to setup the Weight Adjustment File.</b>"),
                                 size = "s", easyClose = TRUE, fade = TRUE),
                        hr(),
                        h4(strong(HTML("<center>Set Adjustment Inputs<center/>"))),
                        selectInput(inputId = "adjwgt",
                                    label = strong("Select Attribute Containing Initial Site Weights"),
                                    choices = "",
                                    selected = NULL,
                                    multiple = FALSE, 
                                    width = "300px") %>%
                          #Weight helper
                          helper(icon = "circle-question",type = "inline",
                                 title = "Site Weights",
                                 content = c("Choose the column in the Weight Adjustment file which contains the initial site weights. Replace Replacement sites with Base sites. Set additional Replacement site weights to 0."),
                                 size = "s", easyClose = TRUE, fade = TRUE),
                        
                        selectInput(inputId = "adjwgtcat",
                                    label = strong("Select Attribute Containing Weight Categories"),
                                    choices = "",
                                    selected = NULL,
                                    multiple = FALSE, 
                                    width = "300px") %>%
                          #Weight Category helper
                          helper(icon = "circle-question",type = "inline",
                                 title = "Weight Category",
                                 content = c("Choose the column in the Weight Adjustment file which contains the weight adjustment category. A weight adjustment category represents if a Stratum and/or a multi-density category was used in the design as implemented. If the design was unequally stratified, this attribute should contain a combination of the stratum and category used (i.e. Stratum-Category). 
                                             The default is None, which assumes every site is in the same category and an equal probability design is being adjusted."),
                                 size = "s", easyClose = TRUE, fade = TRUE),
                        
                        selectInput(inputId = "adjsitesampled",
                                    label = strong("Select Attribute Containing Site Evaluations"),
                                    choices = "",
                                    selected = NULL,
                                    multiple = FALSE, 
                                    width = "300px") %>%
                          #Site Info helper
                          helper(icon = "circle-question",type = "inline",
                                 title = "Site Evaluation Attributes",
                                 content = c("Choose the column in the Weight Adjustment file which contains attributes defining if the site was sampled, not sampled, and/or non-target."),
                                 size = "s", easyClose = TRUE, fade = TRUE),
                        hr(),
                        strong(HTML("Select Site Evaluation Attributes")) %>%
                          #Site eval helper
                          helper(icon = "circle-question",type = "inline",
                                 title = "Site Evaluation Attributes",
                                 content = c("<b>Sampled Target Sites:</b> Choose the attribute which defines if the site was sampled and found to be member of the target population. This should also include additional sampled replacement sites.",
                                             "<b>Additional Replacements:</b> Choose the attribute which defines if the site is a replacement site and was added to the design without replacing a base site.",
                                             "<b>Non-Target Sites:</b> Choose the attribute which defines if the site was not sampled and found to NOT be a member of the target population.",
                                             "<b>You are not required to input target sites which have not been sampled for reasons such as landowner denials, site was inaccessible, or not evaluated.</b>"),
                                 size = "s", easyClose = TRUE, fade = TRUE),
                        #Select Site Attribute(s) That Apply to Your Dataset
                        column(12, offset = 1,
                               selectInput(inputId = "sampled_site",
                                           label = strong("Sampled Sites"),
                                           choices = "",
                                           selected = NULL,
                                           multiple = TRUE,
                                           width = "200px"), 
                               selectInput(inputId = "addoversample_site",
                                           label = strong("Additional Replacements"),
                                           choices = "",
                                           selected = NULL,
                                           multiple = TRUE,
                                           width = "200px"), 
                               selectInput(inputId = "nontarget_site",
                                           label = strong("Non-Target Sites"),
                                           choices = "",
                                           selected = NULL,
                                           multiple = TRUE,
                                           width = "200px")),
                        checkboxInput(inputId = "frameadj", 
                                      label= strong("Adjust the Weighting Category Frame Size Manually"), 
                                      value = FALSE, 
                                      width = NULL),
                        hr(),
                        uiOutput("frame"),
                        
                        # Press button for analysis 
                        actionButton("adjButton", HTML("<b>Calculate Adjusted <br/> Survey Weights</b>"), icon=icon("circle-play"), 
                                     style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
                      ), #sidebarPanel
                      mainPanel(
                        conditionalPanel(condition = "input.adjButton",
                        uiOutput("table_download"),
                        DT::dataTableOutput("adjtable"),
                        style = "width:600px; overflow-x: scroll;")
                      )#mainPanel
             )#tabPanel(Adjust Weights)
  ) #navbarPage
  # Individual Page Footer
  ,HTML(
    '</article>
    </div>
    <div class="l-page__footer">
      <div class="l-constrain">
        <p><a href="https://www.epa.gov/national-aquatic-resource-surveys/forms/contact-us-about-national-aquatic-resource-surveys">Contact Us</a> to ask a question, provide feedback, or report a problem.</p>
      </div>
    </div>
  </div>'
  ),
  
  # Site Footer
  HTML(
    '</main>
      <footer class="footer" role="contentinfo">
      <div class="l-constrain">
        <img class="footer__epa-seal" src="https://www.epa.gov/themes/epa_theme/images/epa-seal.svg" alt="United States Environmental Protection Agency" height="100" width="100">
        <div class="footer__content contextual-region">
          <div class="footer__column">
            <h2>Discover.</h2>
            <ul class="menu menu--footer">
              <li class="menu__item">
                <a href="https://www.epa.gov/accessibility" class="menu__link">Accessibility</a>
              </li>
              <!--li class="menu__item"><a href="#" class="menu__link">EPA Administrator</a></li-->
              <li class="menu__item">
                <a href="https://www.epa.gov/planandbudget" class="menu__link">Budget &amp; Performance</a>
              </li>
              <li class="menu__item">
                <a href="https://www.epa.gov/contracts" class="menu__link">Contracting</a>
              </li>
              <li class="menu__item">
                <a href="https://www.epa.gov/home/wwwepagov-snapshots" class="menu__link">EPA www Web Snapshot</a>
              </li>
              <li class="menu__item">
                <a href="https://www.epa.gov/grants" class="menu__link">Grants</a>
              </li>
              <li class="menu__item">
                <a href="https://www.epa.gov/ocr/whistleblower-protections-epa-and-how-they-relate-non-disclosure-agreements-signed-epa-employees" class="menu__link">No FEAR Act Data</a>
              </li>
              <li class="menu__item">
                <a href="https://www.epa.gov/web-policies-and-procedures/plain-writing" class="menu__link">Plain Writing</a>
              </li>
              <li class="menu__item">
                <a href="https://www.epa.gov/privacy" class="menu__link">Privacy</a>
              </li>
              <li class="menu__item">
                <a href="https://www.epa.gov/privacy/privacy-and-security-notice" class="menu__link">Privacy and Security Notice</a>
              </li>
            </ul>
          </div>
          <div class="footer__column">
            <h2>Connect.</h2>
            <ul class="menu menu--footer">
              <li class="menu__item">
                <a href="https://www.data.gov/" class="menu__link">Data.gov</a>
              </li>
              <li class="menu__item">
                <a href="https://www.epa.gov/office-inspector-general/about-epas-office-inspector-general" class="menu__link">Inspector General</a>
              </li>
              <li class="menu__item">
                <a href="https://www.epa.gov/careers" class="menu__link">Jobs</a>
              </li>
              <li class="menu__item">
                <a href="https://www.epa.gov/newsroom" class="menu__link">Newsroom</a>
              </li>
              <li class="menu__item">
                <a href="https://www.epa.gov/data" class="menu__link">Open Government</a>
              </li>
              <li class="menu__item">
                <a href="https://www.regulations.gov/" class="menu__link">Regulations.gov</a>
              </li>
              <li class="menu__item">
                <a href="https://www.epa.gov/newsroom/email-subscriptions-epa-news-releases" class="menu__link">Subscribe</a>
              </li>
              <li class="menu__item">
                <a href="https://www.usa.gov/" class="menu__link">USA.gov</a>
              </li>
              <li class="menu__item">
                <a href="https://www.whitehouse.gov/" class="menu__link">White House</a>
              </li>
            </ul>
          </div>
          <div class="footer__column">
            <h2>Ask.</h2>
            <ul class="menu menu--footer">
              <li class="menu__item">
                <a href="https://www.epa.gov/home/forms/contact-epa" class="menu__link">Contact EPA</a>
              </li>
              <li class="menu__item">
                <a href="https://www.epa.gov/web-policies-and-procedures/epa-disclaimers" class="menu__link">EPA Disclaimers</a>
              </li>
              <li class="menu__item">
                <a href="https://www.epa.gov/aboutepa/epa-hotlines" class="menu__link">Hotlines</a>
              </li>
              <li class="menu__item">
                <a href="https://www.epa.gov/foia" class="menu__link">FOIA Requests</a>
              </li>
              <li class="menu__item">
                <a href="https://www.epa.gov/home/frequent-questions-specific-epa-programstopics" class="menu__link">Frequent Questions</a>
              </li>
            </ul>
            <h2>Follow.</h2>
            <ul class="menu menu--social">
              <li class="menu__item">
                <a class="menu__link" aria-label="EPA’s Facebook" href="https://www.facebook.com/EPA">
                  <!-- svg class="icon icon--social" aria-hidden="true" -->
                  <svg class="icon icon--social" aria-hidden="true" viewBox="0 0 448 512" id="facebook-square" xmlns="http://www.w3.org/2000/svg">
                    <!-- use xlink:href="https://www.epa.gov/themes/epa_theme/images/sprite.artifact.svg#facebook-square"></use-->
                    <path fill="currentcolor" d="M400 32H48A48 48 0 000 80v352a48 48 0 0048 48h137.25V327.69h-63V256h63v-54.64c0-62.15 37-96.48 93.67-96.48 27.14 0 55.52 4.84 55.52 4.84v61h-31.27c-30.81 0-40.42 19.12-40.42 38.73V256h68.78l-11 71.69h-57.78V480H400a48 48 0 0048-48V80a48 48 0 00-48-48z"></path>
                  </svg> 
                  <span class="usa-tag external-link__tag" title="Exit EPA Website">
                    <span aria-hidden="true">Exit</span>
                    <span class="u-visually-hidden"> Exit EPA Website</span>
                  </span>
                </a>
              </li>
              <li class="menu__item">
                <a class="menu__link" aria-label="EPA’s Twitter" href="https://twitter.com/epa">
                  <!-- svg class="icon icon--social" aria-hidden="true" -->
                  <svg class="icon icon--social" aria-hidden="true" viewBox="0 0 448 512" id="twitter-square" xmlns="http://www.w3.org/2000/svg">
                    <!-- use xlink:href="https://www.epa.gov/themes/epa_theme/images/sprite.artifact.svg#twitter-square"></use -->
                    <path fill="currentcolor" d="M400 32H48C21.5 32 0 53.5 0 80v352c0 26.5 21.5 48 48 48h352c26.5 0 48-21.5 48-48V80c0-26.5-21.5-48-48-48zm-48.9 158.8c.2 2.8.2 5.7.2 8.5 0 86.7-66 186.6-186.6 186.6-37.2 0-71.7-10.8-100.7-29.4 5.3.6 10.4.8 15.8.8 30.7 0 58.9-10.4 81.4-28-28.8-.6-53-19.5-61.3-45.5 10.1 1.5 19.2 1.5 29.6-1.2-30-6.1-52.5-32.5-52.5-64.4v-.8c8.7 4.9 18.9 7.9 29.6 8.3a65.447 65.447 0 01-29.2-54.6c0-12.2 3.2-23.4 8.9-33.1 32.3 39.8 80.8 65.8 135.2 68.6-9.3-44.5 24-80.6 64-80.6 18.9 0 35.9 7.9 47.9 20.7 14.8-2.8 29-8.3 41.6-15.8-4.9 15.2-15.2 28-28.8 36.1 13.2-1.4 26-5.1 37.8-10.2-8.9 13.1-20.1 24.7-32.9 34z"></path>
                  </svg>
                  <span class="usa-tag external-link__tag" title="Exit EPA Website">
                    <span aria-hidden="true">Exit</span>
                    <span class="u-visually-hidden"> Exit EPA Website</span>
                  </span>
                </a>
              </li>
              <li class="menu__item">
                <a class="menu__link" aria-label="EPA’s Youtube" href="https://www.youtube.com/user/USEPAgov">
                  <!-- svg class="icon icon--social" aria-hidden="true" -->
                  <svg class="icon icon--social" aria-hidden="true" viewBox="0 0 448 512" id="youtube-square" xmlns="http://www.w3.org/2000/svg">
                    <!-- use xlink:href="https://www.epa.gov/themes/epa_theme/images/sprite.artifact.svg#youtube-square"></use -->
                    <path fill="currentcolor" d="M186.8 202.1l95.2 54.1-95.2 54.1V202.1zM448 80v352c0 26.5-21.5 48-48 48H48c-26.5 0-48-21.5-48-48V80c0-26.5 21.5-48 48-48h352c26.5 0 48 21.5 48 48zm-42 176.3s0-59.6-7.6-88.2c-4.2-15.8-16.5-28.2-32.2-32.4C337.9 128 224 128 224 128s-113.9 0-142.2 7.7c-15.7 4.2-28 16.6-32.2 32.4-7.6 28.5-7.6 88.2-7.6 88.2s0 59.6 7.6 88.2c4.2 15.8 16.5 27.7 32.2 31.9C110.1 384 224 384 224 384s113.9 0 142.2-7.7c15.7-4.2 28-16.1 32.2-31.9 7.6-28.5 7.6-88.1 7.6-88.1z"></path>
                  </svg>
                  <span class="usa-tag external-link__tag" title="Exit EPA Website">
                    <span aria-hidden="true">Exit</span>
                    <span class="u-visually-hidden"> Exit EPA Website</span>
                  </span>
                </a>
              </li>
              <li class="menu__item">
                <a class="menu__link" aria-label="EPA’s Flickr" href="https://www.flickr.com/photos/usepagov">
                  <!-- svg class="icon icon--social" aria-hidden="true" -->
                  <svg class="icon icon--social" aria-hidden="true" viewBox="0 0 448 512" id="flickr-square" xmlns="http://www.w3.org/2000/svg">
                    <!-- use xlink:href="https://www.epa.gov/themes/epa_theme/images/sprite.artifact.svg#flickr-square"></use -->
                    <path fill="currentcolor" d="M400 32H48C21.5 32 0 53.5 0 80v352c0 26.5 21.5 48 48 48h352c26.5 0 48-21.5 48-48V80c0-26.5-21.5-48-48-48zM144.5 319c-35.1 0-63.5-28.4-63.5-63.5s28.4-63.5 63.5-63.5 63.5 28.4 63.5 63.5-28.4 63.5-63.5 63.5zm159 0c-35.1 0-63.5-28.4-63.5-63.5s28.4-63.5 63.5-63.5 63.5 28.4 63.5 63.5-28.4 63.5-63.5 63.5z"></path>
                  </svg>
                  <span class="usa-tag external-link__tag" title="Exit EPA Website">
                    <span aria-hidden="true">Exit</span>
                    <span class="u-visually-hidden"> Exit EPA Website</span>
                  </span>
                </a>
              </li>
              <li class="menu__item">
                <a class="menu__link" aria-label="EPA’s Instagram" href="https://www.instagram.com/epagov">
                  <!-- svg class="icon icon--social" aria-hidden="true" -->
                  <svg class="icon icon--social" aria-hidden="true" viewBox="0 0 448 512" id="instagram-square" xmlns="http://www.w3.org/2000/svg">
                    <!-- use xlink:href="https://www.epa.gov/themes/epa_theme/images/sprite.artifact.svg#instagram-square"></use -->
                    <path fill="currentcolor" xmlns="http://www.w3.org/2000/svg" d="M224 202.66A53.34 53.34 0 10277.36 256 53.38 53.38 0 00224 202.66zm124.71-41a54 54 0 00-30.41-30.41c-21-8.29-71-6.43-94.3-6.43s-73.25-1.93-94.31 6.43a54 54 0 00-30.41 30.41c-8.28 21-6.43 71.05-6.43 94.33s-1.85 73.27 6.47 94.34a54 54 0 0030.41 30.41c21 8.29 71 6.43 94.31 6.43s73.24 1.93 94.3-6.43a54 54 0 0030.41-30.41c8.35-21 6.43-71.05 6.43-94.33s1.92-73.26-6.43-94.33zM224 338a82 82 0 1182-82 81.9 81.9 0 01-82 82zm85.38-148.3a19.14 19.14 0 1119.13-19.14 19.1 19.1 0 01-19.09 19.18zM400 32H48A48 48 0 000 80v352a48 48 0 0048 48h352a48 48 0 0048-48V80a48 48 0 00-48-48zm-17.12 290c-1.29 25.63-7.14 48.34-25.85 67s-41.4 24.63-67 25.85c-26.41 1.49-105.59 1.49-132 0-25.63-1.29-48.26-7.15-67-25.85s-24.63-41.42-25.85-67c-1.49-26.42-1.49-105.61 0-132 1.29-25.63 7.07-48.34 25.85-67s41.47-24.56 67-25.78c26.41-1.49 105.59-1.49 132 0 25.63 1.29 48.33 7.15 67 25.85s24.63 41.42 25.85 67.05c1.49 26.32 1.49 105.44 0 131.88z"></path>
                  </svg>
                  <span class="usa-tag external-link__tag" title="Exit EPA Website">
                    <span aria-hidden="true">Exit</span>
                    <span class="u-visually-hidden"> Exit EPA Website</span>
                  </span>
                </a>
              </li>
            </ul>
            <p class="footer__last-updated">
              Last updated on March 30, 2022
            </p>
          </div>
        </div>
      </div>
    </footer>
    <a href="#" class="back-to-top" title="">
      <svg class="back-to-top__icon" role="img" aria-label="">
      <svg class="back-to-top__icon" role="img" aria-label="" viewBox="0 0 19 12" id="arrow" xmlns="http://www.w3.org/2000/svg">
        <!-- use xlink:href="https://www.epa.gov/themes/epa_theme/images/sprite.artifact.svg#arrow"></use -->
        <path fill="currentColor" d="M2.3 12l7.5-7.5 7.5 7.5 2.3-2.3L9.9 0 .2 9.7 2.5 12z"></path>
      </svg>
    </a>'
  )
, style = "width:1300px;")) #fluidPage


server <- function(input, output, session) {
  
  observe({
    updateCollapse(session, "instructions", open = "Overview")
    updateCollapse(session, "instructions", open = "design")
    updateCollapse(session, "instructions", open = "samplesize")
  })
  
  output$citation <-  renderPrint({
    citation(package = "spsurvey")
  })
  
  observe_helpers()
  
  
  observeEvent(input$sidebar_button, {
    shinyjs::toggle(selector = ".sidebar")
    js_maintab <- paste0('$(".tab-pane.active div[role=',"'main'",']")')
    
    if((input$sidebar_button %% 2) != 0) {
      runjs(paste0('
          width_percent = parseFloat(',js_maintab,'.css("width")) / parseFloat(',js_maintab,'.parent().css("width"));
            ',js_maintab,'.css("width","100%");
          '))
    } else {
      runjs(paste0('
          width_percent = parseFloat(',js_maintab,'.css("width")) / parseFloat(',js_maintab,'.parent().css("width"));
            ',js_maintab,'.css("width","");
          '))
    }
  })
  
  
  dbfdata <- reactive({
    
    req(input$filemap)
    shpdf <- input$filemap
    
    previouswd <- getwd()
    uploaddirectory <- dirname(shpdf$datapath[1])
    setwd(uploaddirectory)
    for(i in 1:nrow(shpdf)){
      file.rename(shpdf$datapath[i], shpdf$name[i])
    }
    setwd(previouswd)
    
    att <- read.dbf(paste(uploaddirectory, shpdf$name[grep(pattern="*.dbf$", shpdf$name)], sep="/"))#,  delete_null_obj=TRUE)
    #We add a column called "None" with "None" values to handle designs without strata or categories.
    att <- att %>% mutate(None="None") %>% relocate(None)
  })
  
  sfobject <- reactive({
    req(input$filemap)
    shpdf <- input$filemap
    
    previouswd <- getwd()
    uploaddirectory <- dirname(shpdf$datapath[1])
    #   setwd(uploaddirectory)
    #   for(i in 1:nrow(shpdf)){
    #   file.rename(shpdf$datapath[i], shpdf$name[i])}
    setwd(previouswd)
    
    map <- st_read(paste(uploaddirectory, shpdf$name[grep(pattern="*.shp$", shpdf$name)], sep="/")) %>% 
      mutate(None="None") %>% relocate(None)

    
    if(!is.null(input$legacy)){
    legacyobject <- legacyobject()
    geometry<-class(legacyobject$geometry[[1]])
    frame_type<-strsplit(geometry," ")[[2]]
    
    #Removes legacyobjects from sframe
    if(frame_type=="POINT" || frame_type=="MULTIPOINT") {
      map <- map[!st_geometry(map) %in% st_geometry(legacyobject), , drop = FALSE]
      }
    }
    map <- st_zm(map)
  })
  
  #Identifies geometry type of sample frame for legacy inputs
  # legacytype <- eventReactive(input$filemap, {
  #   sfobject <- sfobject()
  #  geometry<-class(sfobject$geometry[[1]])
  #  strsplit(geometry," ")[[2]]
  #})
  
  
  #Load legacy shapefile
  legacyobject <- reactive({
    req(input$legacy)
    shpdf <- input$legacy
    
    previouswd <- getwd()
    uploaddirectory <- dirname(shpdf$datapath[1])
    setwd(uploaddirectory)
    for(i in 1:nrow(shpdf)){
      file.rename(shpdf$datapath[i], shpdf$name[i])
    }
    setwd(previouswd)
    
    map <- st_read(paste(uploaddirectory, shpdf$name[grep(pattern="*.shp$", shpdf$name)], sep="/")) %>% 
      mutate(None="None") %>% relocate(None)
    map <- st_zm(map)
  })
  
  
  
  
  
  
  
  #Stratum Event
  observe({
    req(dbfdata())
    if(input$caty != "") {
      strat_cols <- dbfdata() %>% select_if(~!is.numeric(.x)) %>% select(-input$caty)
      updateSelectInput(session, "stratum", selected = isolate(input$stratum), choices = c("None", colnames(strat_cols)))
    } else {
      strat_cols <- dbfdata() %>% select_if(~!is.numeric(.x))
      updateSelectInput(session, "stratum", selected = "None", choices = c("None", colnames(strat_cols)))
    }
    
  })
  
  #Category Event
  observe({
    req(dbfdata())
    if(input$stratum != "") {
      caty_cols <- dbfdata() %>% select_if(~!is.numeric(.x)) %>% select(-input$stratum)
      updateSelectInput(session, "caty", selected = isolate(input$caty), choices = c("None", colnames(caty_cols)))
    } else {
      caty_cols <- dbfdata() %>% select_if(~!is.numeric(.x))
      updateSelectInput(session, "caty", selected = "None", choices = c("None", colnames(caty_cols)))
    }
    
  })
  
  #Auxiliary Variable Event
  observe({
    req(input$addoptions==TRUE)
    aux_cols <- dbfdata() %>% select_if(~is.numeric(.x)) 
    updateSelectInput(session, "aux_var", selected = NULL, choices = c("None", colnames(aux_cols)))
  })
  
  
 # observe({
  #  req(!is.null(input$legacy_strat))
   # legacy_cols <- legacyobject() %>% select_if(~!is.numeric(.x))
  #  updateSelectInput(session, "legacy_strat", selected = "", choices = colnames(legacy_cols))
#  })
  
#  observe({
#    req(!is.null(input$legacy_cat))
#    legacy_cols <- legacyobject() %>% select_if(~!is.numeric(.x))
#    updateSelectInput(session, "legacy_cat", selected = "", choices = colnames(legacy_cols))
#  })
  
#  observe({
#    req(!is.null(input$legacy_aux))
#    legacy_cols <- legacyobject() %>% select_if(~!is.character(.x))
#    updateSelectInput(session, "legacy_aux", selected = "", choices = colnames(legacy_cols))
#  })
  
  #Stratum Length
  S <- reactive({
    req(input$stratum)
    if (input$stratum != "None") {
      dbfdata() %>% select(input$stratum) %>% 
        arrange(.data[[input$stratum]]) %>% 
        unique() %>% 
        pluck(input$stratum) %>% n_distinct()
    } else {1
    }
  })
  
  #Category Length
  C <- reactive({
    req(input$caty)
    
    if(input$caty != "None" && input$stratum == "None" || input$caty == "None" && input$stratum == "None"){
      split <- dbfdata() %>% select(input$caty) %>% unique() %>% pluck(input$caty) %>% n_distinct()
    } else if(input$caty != "None" && input$stratum != "None") {
      split <- dbfdata() %>%
        select(input$stratum, input$caty) %>%
        rename(stratum = input$stratum,
               category = input$caty) %>% unique()
      split <- split(split$category, split$stratum)
      split <- lengths(split)
    } else {
      split <- dbfdata() %>%
        select(input$stratum, input$caty) %>%
        rename(stratum = input$stratum,
               category = input$caty) %>% unique()
      split <- split(split$stratum, split$category)
      split <- lengths(simplify2array(split))
    }
  })
  
  #Category Length
  Z <- reactive({
    req(input$caty)
    if (input$caty != "None") {
      dbfdata() %>% select(input$caty) %>% unique() %>% pluck(input$caty) %>% n_distinct()
    } else {1
    }
  })
  
  strat_choices <- reactive({req(dbfdata())
    dbfdata() %>% select(input$stratum) %>% arrange(.data[[input$stratum]]) %>% 
      unique()
  })
  
  caty_choices <- reactive({
    req(dbfdata())
    
    if(input$stratum != "None" && input$caty != "None" || input$stratum != "None" && input$caty == "None") {
      split <- dbfdata() %>%
        select(input$stratum, input$caty) %>% 
        arrange(.data[[input$caty]]) %>%
        rename(stratum = input$stratum,
               category = input$caty) %>% unique()
      split <- split(split$category, split$stratum)
    } else{
      split <- dbfdata() %>% select(input$caty) %>% arrange(.data[[input$caty]]) %>% unique()
    }
  })
  
  
  ####Legacy UI####
  output$legacyfile <- renderUI({
    fileInput(
      inputId = "legacy",
      placeholder = "Optional",
      label = HTML("<b>Choose all files of the Legacy Sites<br/> POINT Shapefile<br/>  Required: (.shp, .dbf, .prj, .shx)</b>"),
      multiple = TRUE,
      accept = c(".shp", ".prj", ".shx", ".dbf", ".sbn", ".sbx", ".cpg"), 
      width = "600px") %>%
      #User legacy helper
      helper(icon = "circle-question",type = "inline",
             title = "Legacy Sample Frame",
             content = c("Legacy Sample Frame is a POINT or MULTIPOINT shapefile which contains sites that have been selected in a previous probability sample and are to be automatically included in a current probability sample. If the user transforms the samples frames CRS to NAD83/Albers Conus, the legacy object will also be transformed. The number of legacy sites must be greater than number of base sites in at least one stratum."),
             size = "s", easyClose = TRUE, fade = TRUE)
  })
  
  
  
  #Render selectInput if stratum name is NOT in design shapefiles column names.
  output$legacystrat <- renderUI({
    req(input$stratum != "None" && input$stratum %!in% colnames(legacyobject()))
    
    legacy_cols <- legacyobject() %>% st_drop_geometry() %>% select_if(~!is.numeric(.x))
    selectInput(inputId = "legacy_strat",
                label = strong("Select Stratum from Legacy File"),
                selected = "None",
                multiple = FALSE,
                choices = colnames(legacy_cols),
                width = "200px") %>%
      helper(icon = "circle-question",type = "inline",
             title = "Legacy Stratum",
             content = c("A Legacy Stratum is the same stratum used for a stratified design. This input is useful if the stratification variable in the legacy shapefile differs from the survey sample frame shapefile."),
             size = "s", easyClose = TRUE, fade = TRUE)
  })
  
  #Render selectInput if category name is NOT in design shapefiles column names.
  output$legacycat <- renderUI({
    req(input$caty != "None" && input$caty %!in% colnames(legacyobject()))
    legacy_cols <- legacyobject() %>% st_drop_geometry() %>% select_if(~!is.numeric(.x))
    selectInput(inputId = "legacy_cat",
                label = strong("Select Category from Legacy File"),
                selected = "None",
                multiple = FALSE,
                choices = colnames(legacy_cols),
                width = "200px") %>%
      helper(icon = "circle-question",type = "inline",
             title = "Legacy Category",
             content = c("A Legacy Category is the same category used for the unequal design. This input is useful if the category variable in the legacy shapefile differs from the survey sample frame shapefile."),
             size = "s", easyClose = TRUE, fade = TRUE)
  })
  
  #Render selectInput if auxiliary variable name is NOT in design shapefiles column names.
  output$legacyaux <- renderUI({
    req(input$addoptions==TRUE && input$aux_var != "None" && input$aux_var %!in% colnames(legacyobject()))
    legacy_cols <- legacyobject() %>% st_drop_geometry() %>% select_if(~is.numeric(.x))
    selectInput(inputId = "legacy_aux",
                label = strong("Select Auxiliary Variable from Legacy File"),
                selected = "",
                multiple = FALSE,
                choices = colnames(legacy_cols),
                width = "200px") %>%
      helper(icon = "circle-question",type = "inline",
             title = "Legacy Auxiliary",
             content = c("A Legacy Auxiliary variable is the same auxiliary variable used for the design. This input is useful if the auxiliary variable in the legacy shapefile differs from the survey sample frame shapefile."),
             size = "s", easyClose = TRUE, fade = TRUE)
  })
  
  
  
  ####Additional UI####
  output$addoptions <- renderUI({
    req(input$addoptions==TRUE)
    
    #DesignID Input
    fixedRow(
      column(6, offset=1,
             
             #Auxiliary variable input
             selectInput(inputId = "aux_var",
                         label = strong("Auxiliary Variable"),
                         choices = "",
                         selected = NULL,
                         multiple = FALSE, 
                         width = "200px") %>%
               #Auxiliary variable helper
               helper(icon = "circle-question",type = "inline",
                      title = "Auxiliary Variable",
                      content = c("Used for proportional probability selection where the selection for each sampling unit in the population is proportional to a positive <b>Auxiliary Variable</b>.
                                   Larger values of the auxiliary variable result in higher inclusion probabilities. Can be used in unstratified or stratified sampling."),
                      size = "s", easyClose = TRUE, fade = TRUE),
             
             #Reproducible seed input
             numericInput("seed", strong(HTML("Set Reproducible</br> Seed")), rseed, width = "200px") %>%
               #Random Seed helper
               helper(icon = "circle-question",type = "inline",
                      title = "Reproducible Seed",
                      content = c("The randomization of the design is indexed by a 'seed'.",
                                  "A reproducible seed allows the user to obtain an identical draw when the same seed is used. If you wish to reproduce a previously constructed survey design, use the seed value from that design.",
                                  "Each time the tool is closed and reopened, a new random seed is used."),
                      size = "s", easyClose = TRUE, fade = TRUE),
             
             #DesignID input
             textInput(inputId = "DesignID", 
                       label = strong("DesignID"), 
                       value = "Site", 
                       width = "200px") %>%
               #DesignID helper
               helper(icon = "circle-question",type = "inline",
                      title = "DesignID",
                      content = c("A character string indicating the naming structure for each site's identifier selected in the sample, which is included as a variable in the shapefile in the tools output."),
                      size = "s", easyClose = TRUE, fade = TRUE),
             
             #Minimum Distance input
             numericInput(inputId = "mindist", 
                          label = strong("Minimum Distance"),
                          value = NA, min = NA, max = NA, width="200px") %>%
               #Minimum Distance helper
               helper(icon = "circle-question",type = "inline",
                      title = "Minimum Distance",
                      content = c("A numeric value indicating the desired minimum distance between sampled sites. If design is stratified, then minimum distance is applied separately for each stratum. The units must match the units in the sample frame."),
                      size = "s", easyClose = TRUE, fade = TRUE),
             
             #Maximum Attempts input
             numericInput(inputId = "maxtry", 
                          label = strong("Maximum Attempts"), 
                          value = 10, min = 0, max = NA, width="200px") %>%
               #Maximum Attempts helper
               helper(icon = "circle-question",type = "inline",
                      title = "Maximum Attempts",
                      content = c("The number of maximum attempts to apply the minimum distance algorithm to obtain the desired minimum distance between sites. Each iteration takes roughly as long as the standard GRTS algorithm. Successive iterations will always contain at least as many sites satisfying the minimum distance requirement as the previous iteration. The algorithm stops when the minimum distance requirement is met or there are maximum attempt iterations. The default number of maximum iterations is 10."),
                      size = "s", easyClose = TRUE, fade = TRUE),
             
             #Nearest neighbor input
             numericInput(inputId = "n_near", 
                          label = strong("Nearest Neighbor Replacement Sites"), 
                          value = NA, min = 1, max = 10, width="200px") %>%
               #n_near helper
               helper(icon = "circle-question",type = "inline",
                      title = "Nearest Neighbor Replacements",
                      content = c("An integer from 1 to 10 specifying the number of nearest neighbor replacement sites to be selected for each base site. For point sample frames, the distance between a site and its nearest neighbor depends on point density. This tool does not offer stratum-specific nearest neighbor requirements."),
                      size = "s", easyClose = TRUE, fade = TRUE),
             #Point Density input
             numericInput(inputId = "pt_density", 
                          label = strong("Point Density"), 
                          value = 10, min = 1, max = NA, width="200px") %>%
               #n_near helper
               helper(icon = "circle-question",type = "inline",
                      title = "Point Density",
                      content = c("A positive integer controlling the density of the GRTS approximation for infinite sampling frames. 
                         The default value of pt_density is 10. Note that when used with categories, the unequal inclusion probabilities generated from this approach are also approximations."),
                      size = "s", easyClose = TRUE, fade = TRUE)))
  })
  
  
  ####MainPanel UI####
  output$mytabs = renderUI({
    do.call(tabsetPanel, c(lapply(1:S(), function(s) {
      tabPanel(strong(paste0("Stratum: ", strat_choices()[s,1])),
               fixedRow(
                 column(3,
                        #Stratum Inputs
                        selectInput(inputId = paste0("strat",s),
                                    label = paste0("Stratum ",s),
                                    choices = strat_choices()[s,1],
                                    selected = "",
                                    multiple = FALSE) %>%
                          #Strata helper
                          helper(icon = "circle-question",type = "inline",
                                 title = "Stratum",
                                 content = c("Choose a stratum which defines how your sample sites will be stratified.",
                                             "If your design is not stratified, use the default <b>None</b>."),
                                 size = "s", easyClose = TRUE, fade = TRUE)),
                 
                 column(2, 
                        #Stratum Base sample sizes
                        numericInput(inputId = paste0("strat",s,"_base"), 
                                     label = "Base Sites",
                                     width = "100px",
                                     value = 0, min = 0, max = 10000) %>%
                          #Base helper
                          helper(icon = "circle-question",type = "inline",
                                 title = "Base Sites",
                                 content = c("If the design is unstratified, <b>Base Sites</b> is the overall sample size of the survey. If your design is stratified, set the sample size for each strata."),
                                 size = "s", easyClose = TRUE, fade = TRUE),
                        numericInput(inputId = paste0("Over",s), 
                                     label = "Replacement Sites",
                                     width = "100px",
                                     value = 0, min = 0, max = 10000) %>%
                          #Replacement helper
                          helper(icon = "circle-question",type = "inline",
                                 title = "Replacement Sites",
                                 content = c("Define number of Replacement sites needed for a stratum.",
                                             "Replacement sites are a set of spatially balanced sites that can be used for the replacement of a non-target or inaccessible sites.
                                                Misuse can cause spatial imbalance in your survey."),
                                 size = "s", easyClose = TRUE, fade = TRUE)),
                 
                 conditionalPanel(condition="input.caty != 'None'",
                                  column(3, offset = 1,
                                         #Category Inputs
                                         lapply(1:C()[s], function(i) {
                                           selectInput(inputId = paste0("S",s,"_C",i),
                                                       label = paste0("Category ",i),
                                                       choices = caty_choices()[[s]][i],
                                                       selected = "",
                                                       multiple = FALSE)
                                         }) %>%
                                           #Category helper
                                           helper(icon = "circle-question",type = "inline",
                                                  title = "Multi-density Categories",
                                                  content = c("Name and set the sample size of each Category.",
                                                              "<b>Note:</b> The total sample size defined in category inputs must equal the total sample size defined in the Base input."),
                                                  size = "s", easyClose = TRUE, fade = TRUE)),
                                  column(3,
                                         lapply(1:C()[s], function(i) {
                                           numericInput(inputId = paste0("S",s,"_C",i,"_Site"), 
                                                        label = paste0("Category ",i," Sites"),
                                                        width = "80px",
                                                        value = "0", min = 0, max = 100000)
                                         })
                                  )
                 )#Conditionalpanel
               )#fixedRow
      )#tabPanel
    }))#stratum apply  
    ) #tabsetPanel
  })#renderUI
  
  ####SF Summary####
  sumdata <- reactive({
    req(dbfdata(), sfobject(), input$stratum, input$caty)
    
    sfobject <- sfobject()
    if(input$NAD83 == TRUE) {
      sfobject <- st_transform(sfobject, crs = 5070)
    }
    
    geometry<-class(sfobject$geometry[[1]])
    frame_type<-strsplit(geometry," ")[[2]]
    
    if(frame_type=="MULTIPOLYGON" || frame_type=="POLYGON") {
      Dist <- st_area(sfobject)
      Dist <- as.data.frame(Dist)
      st_geometry(sfobject) <- NULL
      sumdata <- cbind(sfobject, Dist)
    } else if(frame_type=="POINT" || frame_type=="MULTIPOINT" && is.null(input$legacy)) {
      sumdata <- sfobject() %>% st_drop_geometry() %>% mutate(Dist = 1)
    } else {
      Dist <- st_length(sfobject)
      Dist <- as.data.frame(Dist)
      st_geometry(sfobject) <- NULL
      sumdata <- cbind(sfobject, Dist)
    }
    sumdata
  })
  
  output$SF_SUM <- renderDataTable({
    req(dbfdata(), sfobject(), input$stratum, input$caty)
    
    if(input$stratum != "None" || input$caty != "None"){
      Summary <- sumdata() %>%
        rename(STRATUM = input$stratum,
               CATEGORY = input$caty) %>%
        group_by(STRATUM, CATEGORY) %>%
        summarise(RESOURCE_units = round(sum(Dist)), .groups = 'drop') %>%
        mutate(`Proportion_%` = round((RESOURCE_units/sum(RESOURCE_units))*100, 1)) %>%
        group_split(STRATUM) %>% 
        map_dfr(~ .x %>% 
                  janitor::adorn_totals(.) %>%
                  mutate(STRATUM = replace(STRATUM, n(), str_c(STRATUM[n()], "_", 
                                                               first(STRATUM)))))
      
      rows <- nrow(Summary)
      DT::datatable(Summary, rownames=F, options = list(pageLength = rows, dom = 't')) %>% 
        formatStyle('CATEGORY',
                    target = 'row',
                    fontWeight = styleEqual(c("-"), c('bold')))
      
    } else {
      Summary <- sumdata() %>%
        rename(GROUP = None) %>%
        group_by(GROUP) %>%
        summarise(RESOURCE_units = sum(Dist), .groups = 'drop') %>%
        mutate(RESOURCE_units = round(RESOURCE_units))
      
      rows <- nrow(Summary)
      DT::datatable(Summary, rownames=F, options = list(pageLength = rows, dom = 't')) %>%
        formatStyle('RESOURCE_units', fontWeight = 'bold')
    }
  })
  
  
  ####Legacy Summary####
  legacysum <- reactive({
    req(legacyobject())
    sumdata <- legacyobject() %>% st_drop_geometry() %>% mutate(Dist = 1)
  })
  
  output$LEGACY_SUM <- renderDataTable({
    req(legacyobject())
  
  if(input$stratum %in% colnames(legacyobject()) && input$caty %in% colnames(legacyobject())) {
    if(input$stratum != "None" || input$caty != "None"){
      Summary <- legacysum() %>%
        rename(STRATUM = input$stratum,
               CATEGORY = input$caty) %>%
        group_by(STRATUM, CATEGORY) %>%
        summarise(RESOURCE_units = round(sum(Dist)), .groups = 'drop') %>%
        mutate(`Proportion_%` = round((RESOURCE_units/sum(RESOURCE_units))*100, 1)) %>%
        group_split(STRATUM) %>% 
        map_dfr(~ .x %>% 
                  janitor::adorn_totals(.) %>%
                  mutate(STRATUM = replace(STRATUM, n(), str_c(STRATUM[n()], "_", 
                                                               first(STRATUM)))))
      
      rows <- nrow(Summary)
      DT::datatable(Summary, rownames=F, options = list(pageLength = rows, dom = 't')) %>% 
        formatStyle('CATEGORY',
                    target = 'row',
                    fontWeight = styleEqual(c("-"), c('bold')))
      
    } else {
      Summary <- legacysum() %>%
        rename(GROUP = None) %>%
        group_by(GROUP) %>%
        summarise(RESOURCE_units = sum(Dist), .groups = 'drop') %>%
        mutate(RESOURCE_units = round(RESOURCE_units))
      
      rows <- nrow(Summary)
      DT::datatable(Summary, rownames=F, options = list(pageLength = rows, dom = 't')) %>%
        formatStyle('RESOURCE_units', fontWeight = 'bold')
    }
    } else{
    Summary <- legacysum() %>%
      rename(GROUP = None) %>%
      group_by(GROUP) %>%
      summarise(RESOURCE_units = sum(Dist), .groups = 'drop') %>%
      mutate(RESOURCE_units = round(RESOURCE_units))
    
    rows <- nrow(Summary)
    DT::datatable(Summary, rownames=F, options = list(pageLength = rows, dom = 't')) %>%
      formatStyle('RESOURCE_units', fontWeight = 'bold')
    }
  })
  
  
  
  #Updates Aux var type based on category input
  observe({
    req(input$aux_var != "None") 
    updateSelectInput(session, "caty", 
                      selected = "None")
  })
  
  
  observe({
    req(input$caty != "None" | input$stratum != "None") 
    updateSelectInput(session, "aux_var", 
                      selected = "None")
  })
  
  #Transfers user to Survey Design Results tab after pressing button
  observeEvent(input$goButton, {
    updateNavbarPage(session, "inTabset",
                     selected = "Step 3: Survey Design Results")
  })
  
  #Observer to sum categorical sites to update stratum base sites 
  observe({
    req(input$caty != "None" && input$S1_C1 != "None")
    
    sumCAT <- list() #empty list
    for(i in 1:S()) {
      for (x in 1:C()[i]) {
        sumCAT[[paste0("strat", i)]][paste0("S",i, "_C",x)] = input[[paste0("S",i,"_C",x,"_Site")]]
      }
    }
    sumCAT <- sapply(sumCAT, sum)
    
       lapply(1:S(), function(s) {
      updateNumericInput(session, 
                         paste0("strat",s,"_base"),  
                         value = unname(sumCAT[s]))
  })
 })
  

  ####Design####
  DESIGN <- eventReactive(input$goButton,{
    
    #Validates there is a complete sample frame added
    CRS <- st_crs(sfobject())
    
    validate(
      need(input$filemap != FALSE, 
           "Please input a Sample Frame."),
      need(!is.na(CRS),  
           "Please input the required file .prj of the sample frame."),
      if(!is.null(input$legacy)) {
        sumSTRAT<- c() #empty vector
        for(i in 1:S()) {
          sumSTRAT[[paste0("strat", i)]] = input[[paste0("strat",i,"_base")]]
        }
        sumSTRAT <- sum(unlist(sumSTRAT))
        legacypoints<- npts(legacyobject())
        need(legacypoints < sumSTRAT,
             "The number of legacy sites is greater than number of base sites in at least one stratum. 
      Please check that all strata have fewer legacy sites than base sites.")
    })
    
    show_modal_spinner(spin = 'flower', text = 'Processing...If the Design is taking too long or has timed out, consider visiting the apps GitHub site
                       and launching it locally for much improved processing.')
    
    #Sets reproducible seed
    if (input$addoptions == TRUE) {
      set.seed(input$seed)
    } else {
      set.seed(rseed)
    }
    
    ####Strata Conditionals####
    #Unstratified 
    if (input$stratum == "None") {
      stratum_var <- NULL
      n_base <- input$strat1_base
      #Stratified
    } else {
      stratum_var <- input$stratum
      #Creates Stratum named vector
      n_base <- c() #empty vector
      for(i in 1:S()) {
        n_base[[paste0("strat", i)]] = input[[paste0("strat",i,"_base")]]
        #Renames vectors
        name<-input[[paste0('strat',i)]]
        names(n_base)[i] <- name
      }
      n_base <- unlist(n_base)
    }
    
    ####Category Conditionals####
    #equal probablity
    if (input$caty == "None") {
      caty_var <- NULL
      caty_n <- NULL
      
      #Stratified, unequal probability
    } else if (input$caty != "None" && input$stratum != "None") {
      caty_var <- input$caty
      
      #Creates Category List
      caty_n <- list() #empty list
      for(i in 1:S()) {
        for (x in 1:C()[i]) {
          caty_n[[paste0("strat", i)]][paste0("S",i, "_C",x)] = input[[paste0('S',i,'_C',x, "_Site")]]
          #Renames Category names in list
          catname <- input[[paste0("S",i,"_C",x)]]
          names(caty_n[[i]])[x] <- catname
        }
      }
      
      #Renames Strata names in Categorical list
      for(i in 1:S()) {
        stratname <- input[[paste0("strat", i)]]
        names(caty_n)[i] <- stratname
      }
      #Removes categories == 0
      #caty_n <- lapply(caty_n, function(x) {x[x!=0]})
      #Unstratified, Unequal Probability
    } else {
      caty_var <- input$caty
      #Creates Category named vector
      caty_n <- c() #empty vector
      for(x in 1:Z()) {
        caty_n[[paste0("caty", x)]] = input[[paste0('S1_C',x, "_Site")]]
        #Renames vectors
        catname<-input[[paste0("S1_C",x)]]
        names(caty_n)[x] <- catname
      }
      caty_n <- unlist(caty_n)
    }
    
    ####Replacement Conditionals####
    #input for conditional below
    replace_con <- c()
    for(i in 1:S()) {
      replace_con[[paste0("Over", i)]] = input[[paste0('Over',i)]]
      stratname <- input[[paste0("strat", i)]]
      names(replace_con)[i] <- stratname
    }
    replace_con <- unlist(replace_con)
    replace_con <- length(unique(replace_con))
    
    #Equal Probability
    if(input$stratum == "None" && input$caty == "None") {
      n_over <- input$Over1
      #Stratified Equal Probability
    } else if (input$stratum != "None" && input$caty == "None") {
      #Creates Replacement sites List
      n_over <- list()
      for(i in 1:S()) {
        n_over[[paste0("Over", i)]] = input[[paste0('Over',i)]]
        stratname <- input[[paste0("strat", i)]]
        names(n_over)[i] <- stratname
      }
      #Unstratified Unequal Probability
    } else if(input$stratum == "None" && input$caty != "None") {
      #Creates replacement named vector
      n_over <- c() #empty vector
      for(i in 1:S()) {
        for(x in 1:C()[i]) {
          n_over[[paste0("caty", x)]] = input$Over1
          #Renames vectors
          catname <- input[[paste0("S1_C",x)]]
          names(n_over)[x] <- catname
        }
      }
      n_over <- unlist(n_over)
      #Stratified Unequal Probability (Where n_over changes among strata) 
      #} else if(input$stratum != "None" && input$caty != "None" && replace_con != 1) {
    }else{
      #Creates replacement List
      n_over <- list() #empty list
      for(i in 1:S()) {
        for (x in 1:C()[i]) {
          n_over[[paste0("strat", i)]][paste0("S",i, "_C",x)] = input[[paste0('Over',i)]]
          #Renames Category names in list
          catname <- input[[paste0("S",i,"_C",x)]]
          names(n_over[[i]])[x] <- catname
        }
        stratname <- input[[paste0("strat", i)]]
        names(n_over)[i] <- stratname
      }
    }  
    #Stratified Unequal Probability (Where n_over DOES NOT change among strata) 
    # } else{
    #   n_over <- list()
    #    for(i in 1:S()) {
    #      n_over[[paste0("Over", i)]] = input[[paste0('Over',i)]]
    #      stratname <- input[[paste0("strat", i)]]
    #      names(n_over)[i] <- stratname
    #    }
    #   }
    
    #Replacement input cannot be 0, this handles this instance by adding all oversamples and checks if its over 0
    for(i in 1:S()) {
      total <- 0
      over <- total + input[[paste0('Over',i)]]
    }
    if (over == 0) {
      n_over <- NULL
    }
    
    ####Legacy Conditionals####    
    
    if(!is.null(input$legacy) && input$NAD83 == TRUE) {
      legacy_sites <- legacyobject()
      legacy_sites <- st_transform(legacy_sites, crs = 5070)
    } else if(!is.null(input$legacy)) {
      legacy_sites <- legacyobject()
    } else {
      legacy_sites <- NULL
    }
    
    
    if(!is.null(input$legacy_strat)) {
      legacy_stratum_var <- input$legacy_strat
    } else {
      legacy_stratum_var <- NULL
    }
    
    if(!is.null(input$legacy_cat)) {
      legacy_caty_var <- input$legacy_cat
    } else {
      legacy_caty_var <- NULL
    }
    
    if(!is.null(input$legacy_aux)) {
      legacy_aux_var <- input$legacy_aux
    } else {
      legacy_aux_var <- NULL
    }
    

    
    ####Additional Attribute Conditionals####
    aux_var <- NULL
    mindis <- NULL
    maxtry <- 10
    n_near <- NULL
    DesignID <- "Site"
    pt_density <- 10
    
    if (input$addoptions == TRUE && input$aux_var != "None") {
      aux_var <- input$aux_var
    }
    if (input$addoptions == TRUE && !is.na(input$mindist)) {
      mindis <- input$mindist
    }
    if (input$addoptions == TRUE && input$maxtry != 10) {
      maxtry <- input$maxtry
    }
    if (input$addoptions == TRUE && !is.na(input$n_near)) {
      n_near <- input$n_near
    } 
    if (input$addoptions == TRUE && input$DesignID != "Site") {
      DesignID <- input$DesignID
    } 
    if (input$addoptions == TRUE && input$pt_density != 10) {
      pt_density <- input$pt_density
    } 
    
    sfobject <- sfobject()
    
    if(input$NAD83 == TRUE) {
      sfobject <- st_transform(sfobject, crs = 5070)
    }
    
    #Removes stop_df if calculate button has been previously pressed
    if(exists('stop_df')) {
      rm('stop_df', envir=.GlobalEnv)
    }
    
    if(input$designtype=="GRTS") {
      
      design <- try(grts(sfobject,
                         n_base = n_base,
                         stratum_var = stratum_var,
                         caty_var = caty_var,
                         caty_n = caty_n,
                         n_over = n_over,
                         aux_var = aux_var,
                         #legacy_var = legacy_var,
                         legacy_sites = legacy_sites,
                         legacy_stratum_var = legacy_stratum_var,
                         legacy_caty_var = legacy_caty_var,
                         legacy_aux_var = legacy_aux_var,
                         mindis = mindis,
                         maxtry = maxtry,
                         n_near = n_near,
                         pt_density = pt_density,
                         DesignID = DesignID))
    }
    
    else {
      design <- try(irs(sfobject,
                        n_base = n_base,
                        stratum_var = stratum_var,
                        caty_var = caty_var,
                        caty_n = caty_n,
                        n_over = n_over,
                        aux_var = aux_var,
                        #legacy_var = legacy_var,
                        legacy_sites = legacy_sites,
                        legacy_stratum_var = legacy_stratum_var,
                        legacy_caty_var = legacy_caty_var,
                        legacy_aux_var = legacy_aux_var,
                        mindis = mindis,
                        maxtry = maxtry,
                        n_near = n_near,
                        pt_density = pt_density,
                        DesignID = DesignID))
    }
    
    remove_modal_spinner()
    
    #If grts or irs is unsuccessful, reactive returns error message data frame (stop_df)
    if(exists('stop_df')){
      stop_df
      #If grts or irs is unsuccessful, reactive returns list (design)
    } else {
      # find the call list
      call_list <- as.list(design$design$call)
      # only replace specific elements
      replace_names <- names(call_list)[!names(call_list) %in% c("", "sframe","legacy_sites")]
      call_list[replace_names] <- lapply(replace_names, function(x) eval(call_list[[x]]))
      # save new call list as a call
      new_call <- as.call(call_list)
      if (input$addoptions == TRUE) {
        rseed <- input$seed
      }
      
      design$design <- data.frame(call = deparse1(new_call), seed = rseed, spsurvey_version = getNamespaceVersion("spsurvey"), r_version = R.version.string)
      
      design
    }
  })
  
  
  ####Design Error####
  output$error <- renderTable({
    if(is.data.frame(DESIGN())) {
      DESIGN()
    } else {
      print("No Design Errors Found. Way To Go!")
    }
  })
  
  
  ####SS Summary####
  output$summary <- renderDataTable({
    
    Summary <- sp_rbind(DESIGN())
    st_geometry(Summary) <- NULL
    Summary <- Summary %>% filter(!(is.na(wgt))) %>%
      group_by(siteuse, stratum, caty) %>%
      summarise(SITES = n(), .groups = 'drop') %>%
      group_split(siteuse) %>% 
      map_dfr(~ .x %>% 
                janitor::adorn_totals(.) %>% 
                mutate(siteuse = replace(siteuse, n(), str_c(siteuse[n()], "_", 
                                                             first(siteuse))))) %>% 
      rename_with(toupper)%>% rename(CATEGORY = CATY)
    rows <- nrow(Summary)
    DT::datatable(Summary, rownames=F, options = list(pageLength = rows, dom = 't')) %>% 
      formatStyle('STRATUM',
                  target = 'row',
                  fontWeight = styleEqual(c("-"), c('bold')))
  })
  
  ####PopEst Sim UI####
  output$conditionprb <- renderUI({
    
    if(input$connumber == "2") {
      fixedRow(
        splitLayout(
          numericInput(inputId = "CON2", 
                       label = "Good Probability (%)", 
                       value = 50, min = 0, max = 100., width = "80px"),
          numericInput(inputId = "CON4", 
                       label = "Poor Probability (%)", 
                       value = 50, min = 0, max = 100, width = "80px")))
    } else if(input$connumber == "3") {
      fixedRow(
        splitLayout(
          numericInput(inputId = "CON2", 
                       label = HTML("Good</br> Probability (%)"), 
                       value = 33, min = 0, max = 100, width = "80px"),
          numericInput(inputId = "CON3", 
                       label = HTML("Fair</br> Probability (%)"), 
                       value = 33, min = 0, max = 100, width = "80px"),
          numericInput(inputId = "CON4", 
                       label = HTML("Poor</br> Probability (%)"), 
                       value = 33, min = 0, max = 100, width = "80px")))
    } else if(input$connumber == "4") {
      fixedRow(
        splitLayout(
          numericInput(inputId = "CON2", 
                       label = HTML("Good</br> Probability (%)"), 
                       value = 25, min = 0, max = 100, width = "80px"),
          numericInput(inputId = "CON3", 
                       label = HTML("Fair</br> Probability (%)"), 
                       value = 25, min = 0, max = 100, width = "80px"),
          numericInput(inputId = "CON4", 
                       label = HTML("Poor</br> Probability (%)"), 
                       value = 25, min = 0, max = 100, width = "80px")),
        numericInput(inputId = "CON5", 
                     label = HTML("Very Poor</br> Probability (%)"), 
                     value = 25, min = 0, max = 100, width = "80px"))
    } else{
      fixedRow(
        splitLayout(
          numericInput(inputId = "CON1", 
                       label = HTML("Very Good</br> Probability (%)"), 
                       value = 20, min = 0, max = 100, width = "80px"),
          numericInput(inputId = "CON2", 
                       label = HTML("Good</br> Probability (%)"), 
                       value = 20, min = 0, max = 100, width = "80px"),
          numericInput(inputId = "CON3", 
                       label = HTML("Fair</br> Probability (%)"), 
                       value = 20, min = 0, max = 100, width = "80px")),
        column(9,
               splitLayout(
                 numericInput(inputId = "CON4", 
                              label = HTML("Poor</br> Probability (%)"), 
                              value = 20, min = 0, max = 100, width = "80px"),
                 numericInput(inputId = "CON5", 
                              label = HTML("Very Poor</br> Probability (%)"), 
                              value = 20, min = 0, max = 100, width = "80px"))))
    }
  })
  
  ####PopEst Simulation####
  samplesize <- eventReactive(c(input$ssbtn, input$goButton), {
    #req(input$CON2, input$CON4)
    
    forcat <- DESIGN()$sites_base
    units(forcat$wgt) <- NULL
    
    
    
    if (input$connumber == "2"){
      forcat$Condition <- sample(c("Good", "Poor"), size = nrow(forcat), replace = TRUE, prob = c(input$CON2, input$CON4))
      colors <- c("#f55b5b", "#5796d1")
    }
    if (input$connumber == "3"){
      forcat$Condition <- sample(c("Good", "Fair", "Poor"), size = nrow(forcat), replace = TRUE, prob = c(input$CON2, input$CON3, input$CON4))
      colors <- c("#f55b5b", "#EE9A00", "#5796d1")
    }
    if (input$connumber == "4"){
      forcat$Condition <- sample(c("Good", "Fair", "Poor", "Very Poor"), size = nrow(forcat), replace = TRUE, prob = c(input$CON2, input$CON3, input$CON4, input$CON5))
      colors <- c("#d15fee", "#f55b5b", "#EE9A00", "#5796d1")
    }
    if (input$connumber == "5"){
      forcat$Condition <- sample(c("Very Good", "Good", "Fair", "Poor", "Very Poor"), size = nrow(forcat), replace = TRUE, prob = c(input$CON1, input$CON2, input$CON3, input$CON4, input$CON5))
      colors <- c("#d15fee", "#f55b5b", "#EE9A00", "#5796d1", "blue")
    }
    
    if (input$stratum == "None") {
      if(input$conflim == "95%") {
        cat_ests <- cat_analysis(
          forcat,
          siteID = "siteID",
          vars = "Condition",
          weight = "wgt")
      } else {
        cat_ests <- cat_analysis(
          forcat,
          siteID = "siteID",
          vars = "Condition",
          weight = "wgt",
          conf = 90)
      }
    }
    
    if (input$stratum != "None") {
      stratum_var <- input$stratum
      if(input$conflim == "95%") {
        cat_ests <- cat_analysis(
          forcat,
          siteID = "siteID",
          vars = "Condition",
          weight = "wgt",
          stratumID = stratum_var)
      } else {
        cat_ests <- cat_analysis(
          forcat,
          siteID = "siteID",
          vars = "Condition",
          weight = "wgt",
          stratumID = stratum_var,
          conf = 90)
      }
    }
    
    cat_ests <- cat_ests %>%
      filter(!(Category == "Total")) %>%
      mutate(Category = factor(Category, levels=c("Very Poor", "Poor", "Fair", "Good", "Very Good"))) %>%
      rename(UCB = contains("UCB") & contains("Pct.P"),
             LCB = contains("LCB") & contains("Pct.P")) %>%
      mutate(Estimate.P = round(Estimate.P, 0),
             UCB = round(UCB, 0),
             LCB = round(LCB, 0),
             MarginofError.P = round(MarginofError.P, 0))
    
    avgMOE <- mean(cat_ests$MarginofError.P)
    avgMOE <- round(cat_ests$MarginofError.P, 0)
    nResp <- sum(cat_ests$nResp)
    #Create Plots
    plot <- ggplot(cat_ests, aes(x = Category, y = Estimate.P)) +
      geom_bar(aes(fill = Category, color = Category), alpha = 0.5, stat="identity", position = position_dodge()) +
      geom_errorbar(aes(ymin = LCB, ymax = UCB, color = Category), linewidth=2, width=0) +
      scale_x_discrete(labels = function(x) str_wrap(x, width = 8)) +
      scale_fill_manual(values = colors) +
      scale_color_manual(values = colors) +
      theme_bw() +
      labs(
        title = paste0("Average Margin of Error: ±", avgMOE,"%"),
        subtitle = paste0("   n=", nResp),
        x = "",
        y = "Percent of Resource") +
      theme(
        plot.title = element_text(size = 16, face = "bold", family="sans", hjust=0.5),
        plot.subtitle = element_text(size = 15, face = "bold", family="sans"),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = "aliceblue"),
        legend.position="none",
        axis.text.x=element_text(face = "bold", size=14),
        axis.text.y=element_text(face = "bold", size=13),
        axis.title.y = element_text(face = "bold", size=14),
        axis.title.x = element_text(face = "bold", size=14)) +
      geom_text(aes(label=paste(format(Estimate.P),"%",
                                sep=""), y=Estimate.P), hjust = -.05, size = 4, fontface = "bold", color = "#4D4D4D", family="sans", position = position_nudge(x = -0.2)) +
      scale_y_continuous(labels = scales::percent_format(scale = 1), breaks=c(0,25,50,75,100)) +
      coord_flip(ylim=c(-2, 110)) +
      geom_text(aes(label=paste(format(LCB),"%",
                                sep=""), y=LCB), hjust = 1.1, size = 3.5, fontface = "bold", 
                color = "#4D4D4D", family="sans", position = position_nudge(x = 0.15)) +
      geom_text(aes(label=paste(format(UCB),"%",
                                sep=""), y=UCB), hjust = -.15,size = 3.5, fontface = "bold", 
                color = "#4D4D4D", family="sans", position = position_nudge(x = 0.15))
    plot
  })
  
  
  output$ssplot <- renderPlot({
    samplesize()
  })
  
  ####Spatial Balance####
  sbresult <- eventReactive(input$balancebtn, {
    #req(input$caty == "None")
    
    if(input$stratum != "None") {
      sp_balance(DESIGN()$sites_base, sfobject(), stratum_var = input$stratum, metrics = input$balance)
    } else {
      sp_balance(DESIGN()$sites_base, sfobject(), metrics = input$balance)  
    } 
  })
  
  output$balance <-  renderPrint({
    sbresult()
  })
  
  ####Call Output####
  output$call <- renderDataTable({
    req(!is.data.frame(DESIGN()))
    
    call <- DESIGN()$design
    
    DT::datatable(
      call,
      callback=JS('$("button.buttons-copy").css("background","#337ab7").css("color", "#fff");
                   $("button.buttons-csv").css("background","#337ab7").css("color", "#fff");
                   $("button.buttons-excel").css("background","#337ab7").css("color", "#fff");
                   return table;'),
      extensions = c("Buttons"),
      rownames = FALSE,
      options = list(dom = 'B',
                     buttons = list(
                       list(extend = 'copy', filename = paste("Design_Setup", Sys.Date(), sep="")),
                       list(extend = 'csv', filename = paste("Design_Setup", Sys.Date(), sep="")),
                       list(extend = 'excel', filename = paste("Design_Setup", Sys.Date(), sep="")))
      ))
  })
  
  
  ####Design Table####
  output$table <- renderDataTable(server = FALSE, {
    req(!is.data.frame(DESIGN()))
    if (input$addoptions == TRUE) {
      rseed <- input$seed
    }
    
    DES_SD <- sp_rbind(DESIGN())  
    #Add xcoord/ycoord
    DES_SD <- DES_SD %>% 
      mutate(xcoord = unlist(map(DES_SD$geometry, 1)),
             ycoord = unlist(map(DES_SD$geometry, 2)), .after = lat_WGS84)
    st_geometry(DES_SD) <- NULL
    DESIGN<- DES_SD %>% filter(!(is.na(wgt))) %>% 
      select(-None) %>% 
      mutate(rep_seed = rseed, .after= "caty")
    
    DT::datatable(
      DESIGN,
      callback=JS('$("button.buttons-copy").css("background","#337ab7").css("color", "#fff");
                   $("button.buttons-csv").css("background","#337ab7").css("color", "#fff");
                   $("button.buttons-excel").css("background","#337ab7").css("color", "#fff");
                   $("button.buttons-pdf").css("background","#337ab7").css("color", "#fff");
                   return table;'),
      extensions = c("Buttons"),
      rownames = FALSE,
      options = list(dom = 'Blrtip',
                     #autowidth = TRUE,
                     scrollX = TRUE,
                     buttons = list(
                       list(extend = 'copy', filename = paste("Survey_Design_", Sys.Date(), sep="")),
                       list(extend = 'csv', filename = paste("Survey_Design_", Sys.Date(), sep="")),
                       list(extend = 'excel', filename = paste("Survey_Design_", Sys.Date(), sep="")),
                       list(extend = 'pdf', filename = paste("Survey_Design_", Sys.Date(), sep="")))
      ))
  })
  

  
  ####Download Shapefile####
  output$shp_btn <- renderUI({
    req(!is.data.frame(DESIGN()))
    downloadButton("download_shp", HTML("Download Survey <br/> Site Shapefile"), icon=icon("compass"), style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
  })
  
  
  output$download_shp <- downloadHandler(
    filename <- function() {
      paste(format(Sys.Date(), "%Y-%m-%d"), "_Survey_Design.zip", sep="")
      
    },
    content = function(file) {
      tmp.path <- dirname(file)
      
      name.base <- file.path(tmp.path, "Survey_Sites")
      name.glob <- paste0(name.base, ".*")
      name.shp  <- paste0(name.base, ".shp")
      name.zip  <- paste0(name.base, ".zip")
      
      if (length(Sys.glob(name.glob)) > 0) file.remove(Sys.glob(name.glob))
      DES_SD <- sp_rbind(DESIGN())
      DES_SD <- DES_SD %>% filter(!(is.na(wgt))) %>% select(-None) #%>% 
      #  mutate(xcoord = unlist(map(DES_SD$geometry, 1)),
       #        ycoord = unlist(map(DES_SD$geometry, 2)), .after = lat_WGS84) 
      
      st_write(DES_SD, dsn = name.shp, ## layer = "shpExport",
               driver = "ESRI Shapefile", quiet = TRUE)
      
      zip::zipr(zipfile = name.zip, files = Sys.glob(name.glob))
      req(file.copy(name.zip, file))
      
      if (length(Sys.glob(name.glob)) > 0) file.remove(Sys.glob(name.glob))
    }  
  )
  
  ####Mapping####
  
  output$map <- renderLeaflet({
    req(input$goButton, DESIGN())
    
    surveypts <- sp_rbind(DESIGN())
    surveypts <- surveypts %>% filter(!(is.na(stratum))) %>% filter(!(is.na(caty))) %>%
      st_transform(crs=4269)
    
    sfobject <- sfobject()
    geometry<-class(sfobject$geometry[[1]])
    frame_type<-strsplit(geometry," ")[[2]]
    
    if (frame_type=="MULTIPOLYGON" || frame_type=="POLYGON") {
      frame_type<-"area"
    } else if (frame_type=="POINT" || frame_type=="MULTIPOINT") {
      frame_type<-"finite"
    } else {
      frame_type<-"linear"
    }
    
    frame <- sfobject %>%
      st_transform(crs=4269) 
    
    m<-mapview(surveypts, zcol = input$color)
    
    
    if(frame_type=="linear") {
      m@map <- m@map %>%
        addPolylines(data=frame, color="#024970") %>%
        addProviderTiles("OpenTopoMap")}
    else if(frame_type=="area") {
      m@map <- m@map %>%
        addPolygons(data=frame, color="#024970") %>%
        addProviderTiles("OpenTopoMap")}
    else {
      m@map <- m@map %>%
        addProviderTiles("OpenTopoMap")}  
    
    m@map
  })
  
  
  output$plot <- renderPlot({
    req(input$goButton, DESIGN())
    
    surveypts <- sp_rbind(DESIGN())
    surveypts <- surveypts %>% filter(!(is.na(stratum))) %>% filter(!(is.na(caty)))
    
    sfobject <- sfobject()
    
    plot<-ggplot()+
      geom_sf(data = sfobject, color = "blue", fill = "blue") +
      geom_sf(data = surveypts, aes_string(color=input$color, shape=input$shape), size=5) +
      scale_color_viridis_d() +
      xlab("Latitude") + ylab("Longitude") +
      labs(color = input$color, shape = input$shape) +
      annotation_scale(location = "bl", width_hint = 0.5) + 
      annotation_north_arrow(location = "tr", height = unit(3, "cm"),
                             width = unit(3, "cm"), which_north = "true", 
                             style = north_arrow_fancy_orienteering) + 
      theme(text=element_text(family="serif"),
            axis.text=element_text(color="#000000", size = 18, face="bold"),
            axis.title=element_text(face="bold", size = 20),
            axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1, color="#000000", size = 18, face="bold"),
            legend.text = element_text(size=16),
            legend.title = element_text(size=18, face="bold"),
            legend.margin=margin(),
            panel.grid.major = element_line(color = gray(0.5), 
                                            linetype = "dashed", size = 0.5), 
            panel.background = element_rect(fill = "aliceblue"))
    print(plot)
  })  
  
  
  ####Weight Adjustment####
  adjdata <- reactive({
    adj<-read.csv(req(input$adjdata$datapath))
  })
  
  
  #Adjustment Weight Input
  observeEvent(adjdata(), {
    adj_cols <- adjdata() %>% select_if(~is.numeric(.x)) 
    updateSelectInput(session, "adjwgt", selected = NULL, choices = c("Required" = "", colnames(adj_cols)))
  })
  
  #Adjustment Weight Category Input
  observeEvent(adjdata(), {
    adj_cols <- adjdata() %>% select_if(~!is.numeric(.x)) 
    updateSelectInput(session, "adjwgtcat", selected = NULL, choices = c("None", colnames(adj_cols)))
  })
  
  #Adjustment Site Input
  observeEvent(adjdata(), {
    adj_cols <- adjdata() %>% select_if(~!is.numeric(.x)) 
    updateSelectInput(session, "adjsitesampled", selected = NULL, choices = c("Required" = "", colnames(adj_cols)))
  })
  
  #Sites Sampled Reactive
  sampled_choices <- reactive({ 
    adjdata() %>% select(input$adjsitesampled) %>% unique() %>% pull()
  })
  
  
  #Sites sampled Events
  observeEvent(input$adjsitesampled, {
    updateSelectInput(session,'sampled_site', selected = NULL, choices = c("Required" = "", sampled_choices()))
  })
  
  #Additional Oversample sampled Events
  observeEvent(input$adjsitesampled, {
    updateSelectInput(session,'addoversample_site', selected = NULL, choices = c(sampled_choices()))
  })
  
  #Sites sampled Events
  observeEvent(input$adjsitesampled, {
    updateSelectInput(session,'nontarget_site', selected = NULL, choices = c(sampled_choices()))
  })
  
  catname <- reactive({ 
    adjdata() %>% pluck(input$adjwgtcat) %>% unique()
  })
  
  output$frame <- renderUI({
    req(input$frameadj==TRUE)
    
    if (input$adjwgtcat != "None") {
      lapply(catname(), function(i) {
        numericInput(
          inputId=paste0("CAT_", i),
          label=paste0(i, "-Frame Size"),
          value=0,
          width = "200px")
      })
    } else {
      numericInput(
        inputId = "CAT_1",
        label = "Frame Size",
        value = 0,
        width = "200px")
    }
  })
  
  output$table_download <- renderUI({
    req(adjbutton())
    downloadButton("adjdownload", HTML("<b>Download Adjusted <br/> Weights Table</b>"), style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
  })
  
  #Weight Adjustment
  adjbutton <- eventReactive(input$adjButton,{
    validate(
      need(input$adjwgt != "", 
           "Please input initial site weights."),
      need(input$adjsitesampled != "", 
           "Please input site evaluations."),
      need(input$sampled_site != "", 
           "Please input attribute(s) which indicate site has been sampled."),
    )
    
    adjdata <- adjdata() %>% mutate(None = "None")
    
    wgt <- adjdata %>% pluck(input$adjwgt)
    
    if (input$adjwgtcat == "None") {
      wtcat <- NULL
    } else {
      wtcat <- adjdata %>% pluck(input$adjwgtcat)
    }
    
    
    sites <- adjdata %>% 
      mutate(SITES_SAMPLED = case_when(.data[[input$adjsitesampled]] %in% .env$input$sampled_site ~ TRUE,
                                       TRUE ~ FALSE)) %>% pluck("SITES_SAMPLED") 
    
    #Calculate Sample Frame Size
    if (input$frameadj == FALSE) {
      tpextentframesize <- adjdata %>% 
        filter(!(.data[[input$adjsitesampled]] %in% .env$input$addoversample_site)) %>%
        group_by(.data[[input$adjwgtcat]]) %>% 
        summarize(SUM = sum(.data[[input$adjwgt]])) %>%
        pivot_wider(names_from = .data[[input$adjwgtcat]], values_from = "SUM") %>% unlist()
      
      tpcoreframesize <- adjdata %>% 
        filter(!(.data[[input$adjsitesampled]] %in% c(.env$input$nontarget_site, .env$input$addoversample_site))) %>%
        group_by(.data[[input$adjwgtcat]]) %>% 
        summarize(SUM = sum(.data[[input$adjwgt]])) %>%
        pivot_wider(names_from = .data[[input$adjwgtcat]], values_from = "SUM") %>% unlist()
      
      
      WGT_TP_EXTENT <- adjwgt(wgt, wtcat, tpextentframesize, sites)
      WGT_TP_CORE <- adjwgt(wgt, wtcat, tpcoreframesize, sites)
      
      df <- cbind(adjdata, WGT_TP_EXTENT, WGT_TP_CORE)
    }
    else {
      if(input$adjwgtcat != "None") {
        datalist <- list()
        for (n in catname()) {
          framesize <- input[[paste0("CAT_",n)]]
          datalist[[n]] <- framesize
        } 
        framesize <- do.call(cbind.data.frame, datalist)
        framesize <- unlist(framesize)
        
        ADJWGT <- adjwgt(wgt, wtcat, framesize, sites)
        
        #adjdata <- adjdata()
        df <- cbind(adjdata, ADJWGT)
      } else {
        framesize <- input$CAT_1
        ADJWGT <- adjwgt(wgt, wtcat, framesize, sites)
        df <- cbind(adjdata, ADJWGT)
      }
    }
    
    df <- df %>% select(!(None))
    df
    
  })
  
  
  output$adjtable <- renderDataTable({
    if(input$adjButton) {
      adjbutton() 
    } else {
      adjdata()  
    }
  })
  
  output$adjdownload <- downloadHandler(
    filename = function() {
      paste("Survey_adjwgts_", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(adjbutton(), file, row.names = FALSE)
    })
  
  #session$onSessionEnded(stopApp) 
}
# shinyApp()
shinyApp(ui = ui, server = server)
