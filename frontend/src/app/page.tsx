"use client";

import { motion } from "framer-motion";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { ShoppingBasket, Search } from "lucide-react";

export default function Home() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-background to-muted flex flex-col">
      <header className="p-6 flex items-center justify-between border-b bg-background/50 backdrop-blur-sm sticky top-0 z-10">
        <div className="flex items-center gap-2 font-bold text-xl text-primary">
          <ShoppingBasket className="w-6 h-6" />
          MealMate
        </div>
        <Button variant="ghost">Login</Button>
      </header>

      <main className="flex-1 flex flex-col items-center justify-center p-4 gap-8">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5 }}
          className="text-center space-y-4 max-w-2xl"
        >
          <h1 className="text-4xl md:text-6xl font-extrabold tracking-tight">
            Eat Well, <span className="text-primary">Spend Less</span>
          </h1>
          <p className="text-xl text-muted-foreground">
            Find the best grocery deals in your area and get personalized budget-friendly recipes instantly.
          </p>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, scale: 0.95 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ delay: 0.2, duration: 0.5 }}
          className="w-full max-w-md"
        >
          <Card>
            <CardHeader>
              <CardTitle>Find Local Deals</CardTitle>
              <CardDescription>Enter your postal code to get started</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="flex w-full items-center space-x-2">
                <Input type="text" placeholder="e.g. 10001" />
                <Button type="submit">
                  <Search className="w-4 h-4 mr-2" />
                  Search
                </Button>
              </div>
            </CardContent>
          </Card>
        </motion.div>
      </main>

      <footer className="p-6 text-center text-sm text-muted-foreground">
        &copy; {new Date().getFullYear()} MealMate. Powered by AI & Caching.
      </footer>
    </div>
  );
}
