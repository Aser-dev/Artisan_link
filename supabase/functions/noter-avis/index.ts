// lib/supabase/functions/noter-avis/index.ts
// NOTE: File is TypeScript for Supabase Edge Functions.

Deno.serve(async (req: Request) => {
  // CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", {
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
        "Access-Control-Allow-Methods": "POST, OPTIONS",
      },
    });
  }

  try {
    if (req.method !== "POST") {
      return new Response(JSON.stringify({ error: "Method not allowed" }), {
        status: 405,
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
          "Access-Control-Allow-Methods": "POST, OPTIONS",
        },
      });
    }

    const body = await req.json().catch(() => ({} as any));
    const commentaire: string | undefined = body.commentaire;

    if (!commentaire || typeof commentaire !== "string" || commentaire.trim().length < 3) {
      return new Response(
        JSON.stringify({ note: 3, raison: "Commentaire trop court" }),
        {
          status: 200,
          headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
            "Access-Control-Allow-Methods": "POST, OPTIONS",
          },
        },
      );
    }

    const OPENROUTER_API_KEY = Deno.env.get("OPENROUTER_API_KEY");
    if (!OPENROUTER_API_KEY) {
      return new Response(JSON.stringify({ note: 3, raison: "Clé OpenRouter manquante" }), {
        status: 500,
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
          "Access-Control-Allow-Methods": "POST, OPTIONS",
        },
      });
    }

    const model = "nvidia/llama-3.1-nemotron-70b-instruct:free";

    const systemPrompt =
      `Tu es un expert en analyse de sentiment pour des avis de clients en français (et pouvant contenir du Mooré).\n` +
      `Tu dois attribuer une note de qualité de service sur 5 étoiles à partir du commentaire.\n` +
      `Retourne UNIQUEMENT un objet JSON valide avec EXACTEMENT ces clés:\n` +
      `- "note": nombre entier entre 1 et 5\n` +
      `- "raison": une phrase courte en français expliquant la note.\n` +
      `Ne retourne aucun texte en dehors du JSON.`;

    const userPrompt = `Commentaire du client:\n${commentaire}\n`;

    const response = await fetch("https://openrouter.ai/api/v1/chat/completions", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${OPENROUTER_API_KEY}`,
        "Content-Type": "application/json",
        "HTTP-Referer": "https://artisanbf.com",
        "X-Title": "ArtisanBF",
      },
      body: JSON.stringify({
        model,
        messages: [
          { role: "system", content: systemPrompt },
          { role: "user", content: userPrompt },
        ],
        temperature: 0.3,
        max_tokens: 120,
      }),
    });

    if (!response.ok) {
      return new Response(JSON.stringify({ note: 3, raison: "Erreur lors de l'appel IA" }), {
        status: 500,
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
          "Access-Control-Allow-Methods": "POST, OPTIONS",
        },
      });
    }

    const data: any = await response.json();
    const content: string =
      data?.choices?.[0]?.message?.content ??
      '{"note":3,"raison":"Analyse par défaut"}';

    let parsed: any;
    try {
      parsed = JSON.parse(content);
    } catch {
      parsed = { note: 3, raison: "Réponse IA non interprétable" };
    }

    const rawNote = parsed?.note ?? 3;
    const noteNum = Number(rawNote);
    const note = Math.min(5, Math.max(1, Math.round(Number.isFinite(noteNum) ? noteNum : 3)));
    const raison = typeof parsed?.raison === "string" && parsed.raison.trim().length > 0
      ? parsed.raison
      : "Analyse par défaut";

    return new Response(JSON.stringify({ note, raison }), {
      status: 200,
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
        "Access-Control-Allow-Methods": "POST, OPTIONS",
      },
    });
  } catch {
    return new Response(JSON.stringify({ note: 3, raison: "Erreur technique" }), {
      status: 500,
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
        "Access-Control-Allow-Methods": "POST, OPTIONS",
      },
    });
  }
});

