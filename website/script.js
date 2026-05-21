document.addEventListener('DOMContentLoaded', function() {
    const navbar = document.getElementById('navbar');
    const navToggle = document.getElementById('navToggle');
    const navMenu = document.querySelector('.nav-menu');
    const tabBtns = document.querySelectorAll('.tab-btn');
    const installPanels = document.querySelectorAll('.install-panel');
    const copyBtns = document.querySelectorAll('.copy-btn');

    window.addEventListener('scroll', function() {
        if (window.scrollY > 50) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }
    });

    if (navToggle) {
        navToggle.addEventListener('click', function() {
            navMenu.classList.toggle('active');
            this.classList.toggle('active');
        });
    }

    document.querySelectorAll('.nav-menu a').forEach(link => {
        link.addEventListener('click', function() {
            navMenu.classList.remove('active');
            navToggle.classList.remove('active');
        });
    });

    tabBtns.forEach(btn => {
        btn.addEventListener('click', function() {
            const tabId = this.dataset.tab;

            tabBtns.forEach(b => b.classList.remove('active'));
            this.classList.add('active');

            installPanels.forEach(panel => {
                panel.classList.remove('active');
                if (panel.id === `${tabId}-panel`) {
                    panel.classList.add('active');
                }
            });
        });
    });

    copyBtns.forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.stopPropagation();
            const target = this.dataset.target;
            let textToCopy = '';

            if (target === 'cran-code') {
                textToCopy = `# Install from CRAN
install.packages("TOmicsVis")

# Load the package
library(TOmicsVis)`;
            } else if (target === 'github-code') {
                textToCopy = `# Install from GitHub
install.packages("devtools")
devtools::install_github("benben-miao/TOmicsVis")

# Load the package
library(TOmicsVis)`;
            } else if (target === 'deps-code') {
                textToCopy = `# Install required Bioconductor packages
install.packages("BiocManager")
BiocManager::install(c(
  "ComplexHeatmap", 
  "EnhancedVolcano", 
  "clusterProfiler", 
  "enrichplot", 
  "impute", 
  "preprocessCore", 
  "Mfuzz"
))`;
            } else if (target === 'quick-code') {
                textToCopy = `# Load example data
data(gene_expression)
data(samples_groups)

# Create a volcano plot
data(degs_stats)
volcano_plot(degs_stats)

# Launch Shiny app
TOmicsVis::tomicsvis()`;
            }

            if (textToCopy) {
                navigator.clipboard.writeText(textToCopy).then(() => {
                    const originalText = this.textContent;
                    this.textContent = 'Copied!';
                    setTimeout(() => {
                        this.textContent = originalText;
                    }, 2000);
                }).catch(err => {
                    console.error('Failed to copy:', err);
                });
            }
        });
    });

    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
            }
        });
    }, observerOptions);

    document.querySelectorAll('.feature-card, .gallery-item, .doc-card').forEach(el => {
        el.classList.add('fade-in');
        observer.observe(el);
    });

    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            const href = this.getAttribute('href');
            if (href !== '#') {
                e.preventDefault();
                const target = document.querySelector(href);
                if (target) {
                    const offsetTop = target.offsetTop - 80;
                    window.scrollTo({
                        top: offsetTop,
                        behavior: 'smooth'
                    });
                }
            }
        });
    });
});

function copyCitation() {
    const citation = `Miao, Ben-Ben, Dong, Wei, Han, Zhao-Fang, Luo, Xuan, Ke, Cai-Huan, and You, Wei-Wei. 2023. "TOmicsVis: An All-in-One Transcriptomic Analysis and Visualization R Package with shinyapp Interface." iMeta e137. https://doi.org/10.1002/imt2.137`;

    navigator.clipboard.writeText(citation).then(() => {
        const btn = event.target;
        const originalText = btn.textContent;
        btn.textContent = 'Copied!';
        setTimeout(() => {
            btn.textContent = originalText;
        }, 2000);
    }).catch(err => {
        console.error('Failed to copy citation:', err);
    });
}
