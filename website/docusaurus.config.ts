import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

// HabitaNexus — sitio público de documentación (migración desde MkDocs).
// Base: https://habitanexus.github.io/monorepo/ (GitHub Pages del repo).

const config: Config = {
  title: 'HabitaNexus',
  tagline: 'Marketplace de alquiler con negociación digital de contratos',
  favicon: 'img/favicon.ico',

  future: {
    v4: true,
  },

  url: 'https://habitanexus.github.io',
  baseUrl: '/monorepo/',

  organizationName: 'HabitaNexus',
  projectName: 'monorepo',

  onBrokenLinks: 'throw',

  i18n: {
    defaultLocale: 'es',
    locales: ['es'],
  },

  markdown: {
    mermaid: true,
  },
  themes: ['@docusaurus/theme-mermaid'],

  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.ts',
          editUrl:
            'https://github.com/HabitaNexus/monorepo/edit/develop/website/',
        },
        blog: false,
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    image: 'img/habitanexus-social-card.jpg',
    colorMode: {
      respectPrefersColorScheme: true,
    },
    navbar: {
      title: 'HabitaNexus',
      logo: {
        alt: 'HabitaNexus',
        src: 'img/logo.svg',
      },
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'docsSidebar',
          position: 'left',
          label: 'Documentación',
        },
        {
          href: 'https://github.com/HabitaNexus/monorepo',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Docs',
          items: [
            {
              label: 'Tutoriales',
              to: '/docs/tutorials',
            },
            {
              label: 'Referencia',
              to: '/docs/reference',
            },
          ],
        },
        {
          title: 'Proyecto',
          items: [
            {
              label: 'GitHub',
              href: 'https://github.com/HabitaNexus/monorepo',
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} HabitaNexus. Built with Docusaurus.`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
