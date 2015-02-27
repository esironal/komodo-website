module.exports = {
    navigation: [
            name: "Home"
            link: "/"
        ,
            name: "Features"
        ,
            name: 'Community'
            link: 'http://forum.komodoide.com/'
            icon: 'sort-down'
            sub: [
                name: "Forums"
                link: "http://forum.komodoide.com/"
            ,
                name: "Screencasts"
            ,
                name: 'Resources'
                link: "{site.url}/resources"
            ,
                name: 'Contribute'
                link: "/resources/submit-instructions/"
            ]
        ,
            name: "Blog"
        ,
            name: "Try"
            link: "{site.url}/download"
        ,
            name: "Buy & Upgrade"
            link: "{site.url}/pricing"
    ]
}
