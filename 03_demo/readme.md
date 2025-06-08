

## dapp
### Create Dapp
```
url: https://sdk.mystenlabs.com/dapp-kit

command: npm create @mysten/dapp
-------> react-client-dapp
```

### UI
Integrated with 'Shadcn' UI components
01. Add Tailwind CSS
```
Shadcn url: https://ui.shadcn.com/docs/installation

command: npm install tailwindcss @tailwindcss/vite                 // this project was built by vite
```

src/index.css
```
@import "tailwindcss";
```

02. Edit tsconfig.json file
add "baseUrl" and "paths" into "compilerOptions"
```
{
    "compilerOptions": {
        "baseUrl": ".",
        "paths": {
            "@/*": ["./src/*"]
        }
    }
}
```

03. Update vite.config.ts
```
command: npm install -D @types/node
```

vite.config.ts
```typescript
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react-swc";
import tailwindcss from "@tailwindcss/vite";
import path from "path"

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react(), tailwindcss()],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
});
```

04. Run the CLI
```
command: npx shadcn@latest init
```

05. Add Components
```
command: npx shadcn@latest add button
```